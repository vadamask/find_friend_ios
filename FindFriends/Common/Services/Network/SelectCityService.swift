import UIKit

struct CitiesModel: Codable {
    var id: Int
    var name: String
}

struct CitiesRequest: NetworkRequest {
    let httpMethod: HttpMethod = .get
    let endpoint = Endpoint.getCities.url
    let dto: Encodable? = nil
    let token: String?
}

final class SelectCityService {
    private let networkClient: NetworkClient
    private let oAuthTokenStorage: OAuthTokenStorageProtocol

    init(networkClient: NetworkClient = DefaultNetworkClient(), oAuthTokenStorage: OAuthTokenStorageProtocol = OAuthTokenStorage.shared) {
        self.networkClient = networkClient
        self.oAuthTokenStorage = oAuthTokenStorage
    }
    
    func getCities(completion: @escaping (Result<[CitiesModel], Error>) -> Void) {
        print("get cities")
        guard let token = oAuthTokenStorage.token else {
            print("No token. Error.")
            return
        }
        let request = CitiesRequest(token: token)
        networkClient.send(request: request, type: [CitiesModel].self) { result in
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
