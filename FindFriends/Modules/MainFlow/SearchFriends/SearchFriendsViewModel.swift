import Combine
import Foundation

final class SearchFriendsViewModel {
    @Published var state: SearchFriendsState = .finishLoading
    private var visibleUsers: [SearchFriendCellViewModel] = []
    private var users: [SearchFriendCellViewModel] = []
    private let service: UsersServiceProtocol
    private var cancellables: Set<AnyCancellable> = []
    
    init(service: UsersServiceProtocol = UsersService()) {
        self.service = service
        bind()
    }
    
    var numberOfRows: Int {
        visibleUsers.count
    }
    
    func userForRowAt(_ indexPath: IndexPath) -> SearchFriendCellViewModel {
        visibleUsers[indexPath.row]
    }
    
    func loadUsers() {
        service.loadUsers()
    }
    
    func cellWillDisplay(at indexPath: IndexPath) {
        if indexPath.row == users.count - 1 {
            loadUsers()
        }
    }
    
    func textDidChanged(_ text: String) {
        if text.isEmpty {
            visibleUsers = users
        } else {
            visibleUsers = users.filter { $0.fullName.contains(text) }
        }
        state = .finishLoading
    }
    
    func didSelectRowAt(_ indexPath: IndexPath) {
        
    }
    
    private func bind() {
        service.state
            .sink { [unowned self] state in
                switch state {
                case .loading:
                    self.state = .loading
                case .finishLoading:
                    users.append(contentsOf: service.convertToViewModels())
                    visibleUsers = users
                    self.state = .finishLoading
                case .error(let error):
                    self.state = .error(error)
                }
            }
            .store(in: &cancellables)
    }
}

