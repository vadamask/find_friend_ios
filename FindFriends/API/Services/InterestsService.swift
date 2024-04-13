//
//  InterestsServiceProvider.swift
//  FindFriends
//
//  Created by Vitaly on 05.03.2024.
//

import Foundation

protocol InterestsServiceProtocol {
    func getInterests(completion: @escaping (Result<[InterestsCellViewModel], Error>) -> Void)
}

final class InterestsService: InterestsServiceProtocol {

    private let networkClient: NetworkClientProtocol

    init(networkClient: NetworkClientProtocol = DefaultNetworkClient()) {
        self.networkClient = networkClient
    }

    func getInterests(completion: @escaping (Result<[InterestsCellViewModel], Error>) -> Void) {
        let request = NetworkRequest(endpoint: .getInterests)
        networkClient.send(request: request, type: [InterestsdResponse].self) { result in
            DispatchQueue.main.async {
                switch result {
                case let .success(interests):
                    completion(.success(interests.map { InterestsCellViewModel(id: $0.id, name: $0.name)}))
                case let .failure(error):
                    completion(.failure(error))
                }
            }
        }
    }
}
