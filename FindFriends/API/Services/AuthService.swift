//
//  LoginService.swift
//  FindFriends
//
//  Created by Вадим Шишков on 04.04.2024.
//

import Foundation

protocol AuthServiceProtocol {
    func loginUser(
        _ dto: LoginRequestDto,
        completion: @escaping (Result<LoginResponseDto, NetworkClientError>) -> Void
    )
    
    func logoutUser(completion: @escaping (Result<Void, NetworkClientError>) -> Void)
}

final class AuthService: AuthServiceProtocol {

    private let networkClient: NetworkClientProtocol
    private let oAuthTokenStorage: OAuthTokenStorageProtocol

    init(
        networkClient: NetworkClientProtocol = DefaultNetworkClient(),
        oAuthTokenStorage: OAuthTokenStorageProtocol = OAuthTokenStorage.shared
    ) {
        self.networkClient = networkClient
        self.oAuthTokenStorage = oAuthTokenStorage
    }

    func loginUser(
        _ dto: LoginRequestDto,
        completion: @escaping (Result<LoginResponseDto, NetworkClientError>) -> Void
    ) {
        let request = NetworkRequest(endpoint: .login, body: dto)
        networkClient.send(request: request, type: LoginResponseDto.self) { result in
            DispatchQueue.main.async {
                switch result {
                case let .success(data):
                    self.oAuthTokenStorage.token = data.authToken
                    completion(.success(data))
                case let .failure(error):
                    completion(.failure(error))
                }
            }
        }
    }
    
    func logoutUser(completion: @escaping (Result<Void, NetworkClientError>) -> Void) {
        let request = NetworkRequest(endpoint: .logout)
        networkClient.send(request: request) { [unowned self] result in
            switch result {
            case .success(_):
                oAuthTokenStorage.token = nil
                completion(.success(Void()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
