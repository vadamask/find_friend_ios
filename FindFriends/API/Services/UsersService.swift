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
    func loadProfile()
    func convertToViewModels() -> [SearchFriendCellViewModel]
    func convertToProfileViewModel() -> MyProfileModel?
    func createUser(
        _ dto: CreateUserRequestDto,
        completion: @escaping (Result<CreateUserResponseDto, NetworkClientError>) -> Void
    )
    func loadMyInfo(completion: @escaping (Result<UserResponse, NetworkClientError>) -> Void)
    func updateMe(_ data: FillProfileDto, completion: @escaping (Result<UserResponse, NetworkClientError>) -> Void)
}

enum SearchFriendsState {
    case loading
    case finishLoading
    case error(NetworkClientError)
}

final class UsersService: UsersServiceProtocol {
 
    let state = CurrentValueSubject<SearchFriendsState, Never>(.finishLoading)
    
    private var usersResponse: [UsersResponse] = []
    private var myProfile: UserResponse?
    private let networkClient: NetworkClientProtocol
    private var page = 1
    
    init(networkClient: NetworkClientProtocol = DefaultNetworkClient()) {
        self.networkClient = networkClient
    }
    
    func createUser(
        _ dto: CreateUserRequestDto,
        completion: @escaping (Result<CreateUserResponseDto, NetworkClientError>) -> Void
    ) {
        let request = NetworkRequest(endpoint: .createUser, body: dto)
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
    
    func loadProfile() {
        guard case .finishLoading = state.value else { return }
        sendProfileRequest()
    }
    
    func convertToProfileViewModel() -> MyProfileModel? {
        let profile = myProfile
        return profile
            .map { MyProfileModel(fullName: "\($0.firstName) \($0.lastName)",
                                  age: $0.age,
                                  avatar: $0.avatar,
                                  purpose: $0.purpose,
                                  interests: $0.interests,
                                  friends: $0.friends,
                                  friendsCount: $0.friendsCount,
                                  city: $0.city,
                                  profession: $0.profession,
                                  networkNick: $0.networkNick
            )}
    }
    
    func loadMyInfo(completion: @escaping (Result<UserResponse, NetworkClientError>) -> Void) {
        let request = NetworkRequest(endpoint: .getMe)
        networkClient.send(request: request, type: UserResponse.self) { [unowned self] result in
            switch result {
            case .success(let userData):
                myProfile = userData
                completion(.success(userData))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func updateMe(_ data: FillProfileDto, completion: @escaping (Result<UserResponse, NetworkClientError>) -> Void) {
        guard let myProfile else {
            print("my profile is nil")
            return
        }
        let dto = UpdateMyProfileDto(
            firstName: myProfile.firstName,
            lastName: myProfile.lastName,
            email: myProfile.email,
            sex: data.sex,
            birthday: data.birthday,
            interests: data.interests,
            city: data.city,
            avatar: data.avatar
        )
        let request = NetworkRequest(endpoint: .updateMe, body: dto)
        networkClient.send(request: request, type: UserResponse.self) { result in
            switch result {
            case .success(let user):
                completion(.success(user))
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func sendProfileRequest() {
        state.send(.loading)
        let request = NetworkRequest(endpoint: .getMe)
        networkClient.send(request: request, type: UserResponse.self) { [unowned self] result in
            switch result {
            case .success(let userData):
                myProfile = userData
                print(self.myProfile as Any)
                self.state.send(.finishLoading)
            case .failure(let error):
                self.state.send(.error(error))
            }
        }
    }
    
    private func sendRequest() {
        state.send(.loading)
        let request = NetworkRequest(endpoint: .getUsers(page))
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
