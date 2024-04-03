//
//  SearchFriendsViewModel.swift
//  FindFriends
//
//  Created by Вадим Шишков on 29.02.2024.
//
import Combine
import Foundation

final class SearchFriendsViewModel {
    @Published var state: State = .empty
    private var users: [SearchFriendCellViewModel] = []
    private let service: UsersServiceProtocol
    private var cancellables: Set<AnyCancellable> = []
    
    init(service: UsersServiceProtocol = UsersService()) {
        self.service = service
        bind()
    }
    
    var numberOfRows: Int {
        users.count
    }
    
    func userForRowAt(_ indexPath: IndexPath) -> SearchFriendCellViewModel {
        users[indexPath.row]
    }
    
    func loadUsers() {
        service.loadUsers()
    }
    
    func cellWillDisplay(at indexPath: IndexPath) {
        if indexPath.row == users.count - 1 {
            loadUsers()
        }
    }
    
    private func bind() {
        service.state
            .sink { [unowned self] state in
                switch state {
                case .empty:
                    self.state = .empty
                case .loading:
                    self.state = .loading
                case .finishLoading:
                    users.append(contentsOf: service.convertToViewModels())
                    self.state = .finishLoading
                case .error(let error):
                    self.state = .error(error)
                }
            }
            .store(in: &cancellables)
    }
}

