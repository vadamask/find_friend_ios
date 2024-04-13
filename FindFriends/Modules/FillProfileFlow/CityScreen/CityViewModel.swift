import Combine
import UIKit

final class CityViewModel {
    
    @Published var selectCity: CityResponse?
    @Published var visibleCities: [String] = []
    var acceptCity = PassthroughSubject<Void, Never>()
    
    
    private let service: CitiesServiceProtocol
    private var allCities: [CityResponse] = [] {
        didSet {
            visibleCities = allCities.map { $0.name }
        }
    }
    
    init(service: CitiesServiceProtocol = CitiesService()) {
        self.service = service
    }
    
    func loadCities() {
        service.loadCities { result in
            switch result {
            case .success(let cities):
                self.allCities = cities
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    func selectButtonTapped() {
        if selectCity != nil {
            acceptCity.send()
        }
    }
    
    func textDidChanged(_ text: String) {
        if text.isEmpty {
            visibleCities = allCities.map { $0.name }
        } else {
            visibleCities = allCities
                .filter { $0.name.hasPrefix(text) }
                .map { $0.name }
        }
    }
    
    func didSelectCityAt(_ indexPath: IndexPath) {
        let name = visibleCities[indexPath.row]
        let id = allCities.first { $0.name == name }?.id
        selectCity = CityResponse(id: id ?? 0, name: name)
    }
}
