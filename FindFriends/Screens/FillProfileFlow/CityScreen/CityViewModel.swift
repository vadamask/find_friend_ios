import UIKit

enum SelectCityState {
    case select
    case nonSelect
}

protocol CityViewModelProtocol {
    var filteredCitiesList: [CitiesModel] {get set }
    var selectCity: String { get set }
    var selectCityObservable: Observable<String> { get }
    var cities: [CitiesModel] { get }
    var citiesObservable: Observable<[CitiesModel]> { get }
    var selectedCity: String { get set }
    //var profileUser: ProfileUser { get set }
}

final class CityViewModel: CityViewModelProtocol {
    
    private let networkService = SelectCityService()
    weak var delegate: ModalViewControllerDelegate?
    @Observable
    private (set) var cities: [CitiesModel] = []
    var filteredCitiesList: [CitiesModel] = []
    
    
    var selectedCity: String = ""
//    var profileUser = ProfileUser(firstName: "Антон", secondName: "Литвинов", location: "Москва", gender: "Мужской", avatar: UIImage(resource: .plugPhoto)) {
//        didSet {
//            profileUser.location = "\(selectedCity)"
//        }
//    }
    var citiesObservable: Observable<[CitiesModel]> { $cities }
    
    //private var profileViewModel = ProfileViewModel()
    
    init() {
        getCities()
    }
    
    private func getCities() {
        networkService.getCities { [weak self] result in
            guard let self else { return }
            DispatchQueue.main.async {
                switch result {
                case let .success(data):
                    print(data)
                    self.cities = data
                case let .failure(error):
                    print(error)
                }
            }
        }
    }
    
    private func selectedCityyy(selected: String) {
        selectedCity = selected
    }
    @Observable
    var selectCity: String = ""
    
    var selectCityObservable: Observable<String> {$selectCity}
    var isSelectedCity: Observable<Bool> = Observable(wrappedValue: false)
    
    func getStateButton(select: SelectCityState) {
        switch select {
        case .select:
            isSelectedCity.wrappedValue = true
        case .nonSelect:
            isSelectedCity.wrappedValue = false
        }
        
        
    }

    func numbersOfRows( _ section: Int) -> Int {
        return filteredCitiesList.count
    }
}
