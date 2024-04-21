import Combine
import Foundation
import SafariServices

final class RegistrationViewModel {
   
    private let usersService: UsersServiceProtocol
    private let authService: AuthServiceProtocol
    private let coordinator: AuthCoordinatorProtocol
    
    @Published var isLoading = false
    
    @Published var allFieldsAreFilling = false
    @Published var personalIsFilling = false
    @Published var passwordIsFilling = false
 
    @Published var name = ""
    @Published var lastName = ""
    @Published var email = ""
    @Published var password = ""
    @Published var confirmPassword = ""
    
    @Published var errorTextForName = ""
    @Published var errorTextForLastName = ""
    @Published var errorTextForEmail = ""
    @Published var errorTextForPassword = ""
    @Published var errorTextForConfirmPassword = ""
    
    private var allFieldsAreValidate: Bool {
        errorTextForName.isEmpty &&
        errorTextForLastName.isEmpty &&
        errorTextForEmail.isEmpty &&
        errorTextForPassword.isEmpty &&
        errorTextForConfirmPassword.isEmpty
    }
    
    init(usersService: UsersServiceProtocol, authService: AuthServiceProtocol, coordinator: AuthCoordinatorProtocol) {
        self.usersService = usersService
        self.authService = authService
        self.coordinator = coordinator
        setupPipline()
    }
    
    func registrationButtonTapped() {
        validateFields()
        if allFieldsAreValidate {
            let user = CreateUserRequestDto(firstName: name, lastName: lastName, email: email, password: confirmPassword)
            isLoading = true
            usersService.createUser(user) { [unowned self] result in
                switch result {
                case .success(let model):
                    let request = LoginRequestDto(email: model.email, password: confirmPassword)
                    authService.loginUser(request) { [unowned self] _ in
                        UserDefaults.standard.removeObject(forKey: "fillingProfile")
                        coordinator.popToRoot()
                    }
                case .failure(let error):
                    coordinator.showAlert(error.message)
                }
                isLoading = false
            }
        }
    }
    
    func agreementDidTapped() {
        guard let url = URL(string: "https://practicum.yandex.ru") else { return }
        let page = SFSafariViewController(url: url)
        coordinator.showPage(page)
    }

    private func setupPipline() {
        let personal = Publishers.CombineLatest3($name, $lastName, $email)
        let password = Publishers.CombineLatest($password, $confirmPassword)
        
        personal
            .map {
                !$0.0.isEmpty &&
                !$0.1.isEmpty &&
                !$0.2.isEmpty
            }
            .assign(to: &$personalIsFilling)
        
        password
            .map {
                !$0.0.isEmpty && !$0.1.isEmpty
            }
            .assign(to: &$passwordIsFilling)
        
        $personalIsFilling.combineLatest($passwordIsFilling)
            .map { $0.0 && $0.1 }
            .assign(to: &$allFieldsAreFilling)
    }
    
    private func validateFields() {
        switch ValidationService.validate(name, type: .name) {
        case .success(_):
            errorTextForName = ValidateMessages.emptyMessage.rawValue
        case .failure(let message):
            errorTextForName = message.rawValue
        }
        
        switch ValidationService.validate(lastName, type: .lastName) {
        case .success(_):
            errorTextForLastName = ValidateMessages.emptyMessage.rawValue
        case .failure(let message):
            errorTextForLastName = message.rawValue
        }
        
        switch ValidationService.validate(email, type: .email) {
        case .success(_):
            errorTextForEmail = ValidateMessages.emptyMessage.rawValue
        case .failure(let message):
            errorTextForEmail = message.rawValue
        }
        
        switch ValidationService.validate(password, type: .password) {
        case .success(_):
            errorTextForPassword = ValidateMessages.emptyMessage.rawValue
        case .failure(let message):
            errorTextForPassword = message.rawValue
        }
        
        if password != confirmPassword {
            errorTextForConfirmPassword = ValidateMessages.passwordsNotEqual.rawValue
        } else {
            switch ValidationService.validate(confirmPassword, type: .confirmPassword) {
            case .success(_):
                errorTextForConfirmPassword = ValidateMessages.emptyMessage.rawValue
            case .failure(let message):
                errorTextForConfirmPassword = message.rawValue
            }
        }
    }
}
