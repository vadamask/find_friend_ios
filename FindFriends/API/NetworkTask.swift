import Foundation

protocol NetworkTaskProtocol {
    func cancel()
}

struct DefaultNetworkTask: NetworkTaskProtocol {
    let dataTask: URLSessionDataTask

    func cancel() {
        dataTask.cancel()
    }
}
