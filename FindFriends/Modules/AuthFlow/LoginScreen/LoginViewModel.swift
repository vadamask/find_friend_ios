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
    let email = CurrentValueSubject<String, Never>("")
    let password = CurrentValueSubject<String, Never>("")

    private let loginService: AuthServiceProtocol
    private let coordinator: AuthCoordinatorProtocol

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
                    networkError = nil
                    coordinator.popToRoot()
                case .failure(let error):
                    coordinator.showAlert(error.message)
                }
                isLoading = false
            }
        }
    }
    
    func didTapRegistrationButton() {
        coordinator.showRegistrationScreen()
    }
    
    func didTapForgotPasswordButton() {
        coordinator.showResetPasswordScreen()
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
