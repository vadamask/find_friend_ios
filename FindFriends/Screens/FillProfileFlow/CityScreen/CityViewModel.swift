import UIKit

class CityViewModel {
    var selectCity: CityResponse?
    @Published var visibleCities: [String] = []
    
    private let service: CitiesServiceProtocol
    private weak var delegate: FillProfileDelegate?
    private var allCities: [CityResponse] = [] {
        didSet {
            visibleCities = allCities.prefix(15).map { $0.name }
        }
    }
    
    init(service: CitiesServiceProtocol = CitiesService(), delegate: FillProfileDelegate) {
        self.service = service
        self.delegate = delegate
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

    func nextButtonTapped() {
        delegate?.cityIsSelect(selectCity?.id)
        delegate?.showControllerWithIndex(4)
    }
    
    func skipButtonTapped() {
        delegate?.cityIsSelect(nil)
        delegate?.showControllerWithIndex(4)
    }
    
    func textDidChanged(_ text: String) {
        if text.isEmpty {
            visibleCities = allCities.prefix(15).map { $0.name }
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
