import UIKit

protocol ProfileViewModelProtocol {
    var profileUser: ProfileUser? { get set }
    var profileObservable: Observable<ProfileUser> { get }
    var profile: ProfileUser { get }
}

final class ProfileViewModel: ProfileViewModelProtocol {
    var profileUser: ProfileUser? 
    
    @Observable
    private (set) var profile: ProfileUser = ProfileUser(firstName: "", secondName: "", location: "", gender: "", avatar: UIImage()) {
        didSet {
            profile.location = cityViewModel.selectedCity
        }
    }
    
    var profileObservable: Observable<ProfileUser> { $profile }
    
    private var cityViewModel: CityViewModelProtocol
    
    var updateProfile: ((ProfileUser) -> Void)?
    
    init(cityViewModel: CityViewModelProtocol = CityViewModel()) {
        self.cityViewModel = cityViewModel
    }
   
}
