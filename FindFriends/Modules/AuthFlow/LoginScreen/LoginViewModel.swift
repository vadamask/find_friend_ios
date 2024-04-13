//
//  LoginViewModel.swift
//  FindFriends
//
//  Created by Artem Novikov on 26.02.2024.
//

import Combine
import Foundation

final class LoginViewModel {

    @Published var emptyFields: Bool = true
    @Published var emailError: String?
    @Published var networkError: String?
    @Published var isLoading = false
    var email = CurrentValueSubject<String, Never>("")
    var password = CurrentValueSubject<String, Never>("")

    private let loginService: AuthServiceProtocol
    private weak var coordinator: AuthCoordinatorProtocol?

    init(loginService: AuthServiceProtocol = AuthService(), coordinator: AuthCoordinatorProtocol) {
        self.loginService = loginService
        self.coordinator = coordinator
        bind()
    }
    
    func didTapLoginButton() {
        isLoading = true
        validateEmail()
        if emailError == nil {
            let dto = LoginRequestDto(email: email.value, password: password.value)
            loginService.loginUser(dto) { [unowned self] result in
                switch result {
                case .success(_):
                    coordinator?.showMainFlow()
                    networkError = nil
                case .failure(let error):
                    networkError = error.message
                }
                isLoading = false
            }
        }
    }
    
    func didTapRegistrationButton() {
        coordinator?.showRegistrationScreen()
    }
    
    func didTapForgotPasswordButton() {
        coordinator?.showResetPasswordScreen()
    }
    
    private func bind() {
        email.combineLatest(password)
            .map { $0.0.isEmpty && $0.1.isEmpty }
            .assign(to: &$emptyFields)
    }
    
    private func validateEmail() {
        switch ValidationService.validate(email.value, type: .email) {
        case .success:
            emailError = nil
        case .failure(let message):
            emailError = message.rawValue
            isLoading = false
        }
    }
}
