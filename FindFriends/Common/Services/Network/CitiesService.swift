//
//  CitiesService.swift
//  FindFriends
//
//  Created by Вадим Шишков on 02.04.2024.
//

import Foundation

protocol CitiesServiceProtocol {
    func loadCities(completion: @escaping (Result<[CityResponse], NetworkClientError>) -> Void)
}

final class CitiesService: CitiesServiceProtocol {
    private let networkClient: NetworkClient
    
    init(networkClient: NetworkClient = DefaultNetworkClient()) {
        self.networkClient = networkClient
    }
    
    func loadCities(completion: @escaping (Result<[CityResponse], NetworkClientError>) -> Void) {
        let request = CityRequest()
        networkClient.send(request: request, type: [CityResponse].self) { result in
            switch result {
            case .success(let cities):
                completion(.success(cities))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
