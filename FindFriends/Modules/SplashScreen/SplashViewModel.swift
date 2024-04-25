import Combine
import Foundation

final class SplashViewModel {
    
    enum SplashState {
        case login
        case unlogin
        case unfinishedRegistration
        case loading
    }
    
    let fillingProfileKey = "fillingProfile"
    var username = PassthroughSubject<String, Never>()
    var state = PassthroughSubject<SplashState, Never>()
    
    private let service: UsersServiceProtocol
    private let oauthTokenStorage = OAuthTokenStorage.shared
    private weak var coordinator: AppCoordinatorProtocol?
    private let userDefaults = UserDefaults.standard
    
    init(service: UsersServiceProtocol, coordinator: AppCoordinatorProtocol) {
        self.service = service
        self.coordinator = coordinator
    }
    
    func viewDidAppear() {
        if let _ = oauthTokenStorage.token {
            if userDefaults.bool(forKey: fillingProfileKey) {
                fetchUsername()
            } else {
                state.send(.unfinishedRegistration)
            }
        } else {
            state.send(.unlogin)
        }
    }
    
    func fetchUsername() {
        state.send(.loading)
        service.loadMyInfo { [unowned self] result in
            switch result {
            case .success(let user):
                self.username.send(user.firstName)
                state.send(.login)
            case .failure(let error):
                coordinator?.showAlert(error.message)
            }
        }
    }
    
    func presentMainFlow() {
        coordinator?.presentMainFlow()
    }
    
    func presentAuthFlow() {
        coordinator?.presentAuthFlow()
    }
    
    func presentFillProfileFlow() {
        coordinator?.presentFillProfileFlow()
    }
}
