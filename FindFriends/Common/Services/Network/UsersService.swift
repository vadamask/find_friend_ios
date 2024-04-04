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
    func createUser(
        _ dto: CreateUserRequestDto,
        completion: @escaping (Result<CreateUserResponseDto, NetworkClientError>) -> Void
    )
}

enum SearchFriendsState {
    case loading
    case finishLoading
    case error(NetworkClientError)
}

final class UsersService: UsersServiceProtocol {
 
    let state = CurrentValueSubject<SearchFriendsState, Never>(.finishLoading)
    
    private var usersResponse: [UsersResponse] = []
    private let networkClient: NetworkClient
    private var page = 1
    
    init(networkClient: NetworkClient = DefaultNetworkClient()) {
        self.networkClient = networkClient
    }
    
    func createUser(
        _ dto: CreateUserRequestDto,
        completion: @escaping (Result<CreateUserResponseDto, NetworkClientError>) -> Void
    ) {
        let request = UsersRequest(httpMethod: .post, endpoint: .createUser, body: dto)
        networkClient.send(request: request, type: CreateUserResponseDto.self) { result in
            DispatchQueue.main.async {
                switch result {
                case let .success(user):
                    completion(.success(user))
                case let .failure(error):
                    completion(.failure(error))
                }
            }
        }
    }
    
    func loadUsers() {
        guard case .finishLoading = state.value else { return }
        if usersResponse.isEmpty {
            sendRequest()
        } else {
            if let last = usersResponse.last,
               let _ = last.next {
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
        networkClient.send(request: request, type: UsersResponse.self) { [unowned self] result in
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
