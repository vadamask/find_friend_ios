import UIKit
import Combine


final class MyProfileViewModel {
    @Published var state: SearchFriendsState = .finishLoading
    @Published var profile: MyProfileModel?
    private let service: UsersServiceProtocol
    private var cancellables: Set<AnyCancellable> = []
    
    
    init(service: UsersServiceProtocol = UsersService()) {
        self.service = service
        bind()
    }
    
    var numberOfItems: Int {
        guard let count = profile?.interests.count else { return 0}
        return count
    }
    
    func cellForItemAt(_ indexPath: IndexPath) -> InterestsdResponse {
        guard let cell = profile?.interests[indexPath.row] else { return InterestsdResponse(id: 0, name: "")}
        return cell
    }
    
    func loadProfile() {
        service.loadProfile()
    }
    
    func bind() {
        service.state
            .sink { [unowned self] state in
                switch state {
                case .loading:
                    loadProfile()
                    self.state = .loading
                case .finishLoading:
                    profile = service.convertToProfileViewModel()
                    self.state = .finishLoading
                case .error(let error):
                    self.state = .error(error)
                }
            }
            .store(in: &cancellables)
    }
}
