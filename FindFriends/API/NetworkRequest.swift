import Foundation

protocol NetworkRequestProtocol {
    var endpoint: Endpoint { get }
    var headers: [String: String] { get }
    var body: Encodable? { get }
}

struct NetworkRequest: NetworkRequestProtocol {
    let endpoint: Endpoint
    var body: (any Encodable)?
    var headers: [String: String] = [
        "Content-Type": "application/json"
    ]
    
    init(endpoint: Endpoint, body: Encodable? = nil) {
        self.endpoint = endpoint
        self.body = body
        
        if let token = OAuthTokenStorage.shared.token {
            self.headers.updateValue("Token \(token)", forKey: "Authorization")
        }
    }
}


