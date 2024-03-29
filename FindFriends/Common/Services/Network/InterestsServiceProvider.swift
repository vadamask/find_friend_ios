//
//  InterestsServiceProvider.swift
//  FindFriends
//
//  Created by Vitaly on 05.03.2024.
//

import Foundation



protocol InterestsServiceProviderProtocol {
    func getInterests(completion: @escaping (Result<[InterestsdDto], Error>) -> Void)
}

final class InterestsServiceProvider: InterestsServiceProviderProtocol {

    private let networkClient: NetworkClient
    private let oAuthTokenStorage: OAuthTokenStorageProtocol

    init(
        networkClient: NetworkClient = DefaultNetworkClient(),
        oAuthTokenStorage: OAuthTokenStorageProtocol = OAuthTokenStorage.shared
    ) {
        self.networkClient = networkClient
        self.oAuthTokenStorage = oAuthTokenStorage
    }

    func getInterests(completion: @escaping (Result<[InterestsdDto], Error>) -> Void) {
        let request = InterstsRequest()
        networkClient.send(request: request, type: [InterestsdDto].self) { result in
            DispatchQueue.main.async {
                switch result {
                case let .success(data):
                    completion(.success(data))
                case let .failure(error):
                    completion(.failure(error))
                }
            }
        }
    }
}
