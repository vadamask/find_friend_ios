import UIKit

protocol CityManagerDelegate: AnyObject {
    func citiesUpdated()
}

class CityViewModel {
    weak var delegate: CityManagerDelegate?
    var selectCity: String = ""
    
    var citiesList: [String] {
        return CityManager.shared.citiesList
    }
    
    var filteredCitiesList: [String] = [] {
        didSet {
            delegate?.citiesUpdated()
        }
    }
}
