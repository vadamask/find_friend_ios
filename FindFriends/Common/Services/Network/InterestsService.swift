//
//  InterestsServiceProvider.swift
//  FindFriends
//
//  Created by Vitaly on 05.03.2024.
//

import Foundation

protocol InterestsServiceProtocol {
    func getInterests(completion: @escaping (Result<[InterestsdResponse], Error>) -> Void)
}

final class InterestsService: InterestsServiceProtocol {

    private let networkClient: NetworkClient

    init(networkClient: NetworkClient = DefaultNetworkClient()) {
        self.networkClient = networkClient
    }

    func getInterests(completion: @escaping (Result<[InterestsdResponse], Error>) -> Void) {
        let request = InterstsRequest()
        networkClient.send(request: request, type: [InterestsdResponse].self) { result in
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
