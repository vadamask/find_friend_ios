//
//  UsersService.swift
//  FindFriends
//
//  Created by Вадим Шишков on 02.04.2024.
//
import Combine
import Foundation

protocol UsersServiceProtocol {
    var state: CurrentValueSubject<SearchFriendsState, Never> { get }
    func loadUsers()
    func convertToViewModels() -> [SearchFriendCellViewModel]
}

enum SearchFriendsState {
    case loading
    case finishLoading
    case error(NetworkClientError)
}

final class UsersService: UsersServiceProtocol {
 
    let state = CurrentValueSubject<SearchFriendsState, Never>(.finishLoading)
    
    private var usersResponse: [UsersResponse] = []
    private let service: NetworkClient
    private var page = 1
    
    init(service: NetworkClient = DefaultNetworkClient()) {
        self.service = service
    }
    
    func loadUsers() {
        guard case .finishLoading = state.value else { return }
        if usersResponse.isEmpty {
            sendRequest()
        } else {
            if let last = usersResponse.last,
               let nextPage = last.next {
                sendRequest()
            }
        }
    }
    
    func convertToViewModels() -> [SearchFriendCellViewModel] {
        guard let last = usersResponse.last else { return [] }
        return last.results
            .map { SearchFriendCellViewModel(
                fullName: "\($0.firstName) \($0.lastName)",
                age: $0.age,
                avatar: $0.avatar,
                purpose: $0.purpose
            )}
    }
    
    private func sendRequest() {
        state.send(.loading)
        let request = UsersRequest(httpMethod: .get, endpoint: .getUsers(page), body: nil)
        service.send(request: request, type: UsersResponse.self) { [unowned self] result in
            switch result {
            case .success(let usersResponse):
                self.usersResponse.append(usersResponse)
                page += 1
                state.send(.finishLoading)
            case .failure(let error):
                state.send(.error(error))
            }
        }
    }
}
