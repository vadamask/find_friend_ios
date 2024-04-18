//
//  AuthCoordinator.swift
//  FindFriends
//
//  Created by Вадим Шишков on 13.04.2024.
//

import SafariServices
import UIKit

protocol AuthCoordinatorProtocol: Coordinator {
    func showRegistrationScreen()
    func showResetPasswordScreen()
    func showVerificationCodeScreen(_ email: String)
    func showNewPasswordScreen(_ token: String)
    func showSuccessScreen()
    func popToLoginVC()
    func popToRoot()
    func showPage(_ page: SFSafariViewController)
    func showAlert(_ message: String)
    func showMainFlow()
}

final class AuthCoordinator: AuthCoordinatorProtocol {
    var navigationController: UINavigationController
    private var loginVC: LoginViewController?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewModel = LoginViewModel(coordinator: self)
        let view = LoginView(viewModel: viewModel)
        let viewController = LoginViewController(loginView: view)
        loginVC = viewController
        self.navigationController.navigationItem.backButtonTitle = nil
        navigationController.pushViewController(viewController, animated: false)
    }
    
    func showMainFlow() {
        navigationController.dismiss(animated: true)
    }
    
    func showAlert(_ message: String) {
        AlertPresenter.show(in: navigationController, model: AlertModel(message: message))
    }
}

// MARK: - Registration

extension AuthCoordinator {
    func showRegistrationScreen() {
        let viewModel = RegistrationViewModel(
            usersService: UsersService(),
            authService: AuthService(),
            coordinator: self
        )
        let view = RegistrationView(viewModel: viewModel)
        let viewController = RegistrationViewController(registrationView: view)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func showPage(_ page: SFSafariViewController) {
        navigationController.present(page, animated: true)
    }
    
    func popToRoot() {
        navigationController.popToRootViewController(animated: true)
    }
}

// MARK: - Reset password routing

extension AuthCoordinator {
    func showResetPasswordScreen() {
        let viewModel = ResetPasswordViewModel(resetPasswordService: ResetPasswordService(), coordinator: self)
        let view = ResetPasswordView(viewModel: viewModel)
        let viewController = ResetPasswordViewController(resetPasswordView: view)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func showVerificationCodeScreen(_ email: String) {
        let viewModel = EnterVerificationCodeViewModel(
            email: email,
            service: ResetPasswordService(),
            coordinator: self
        )
        let view = EnterVerificationCodeView(viewModel: viewModel)
        let viewController = EnterVerificationCodeViewController(enterVerficationCodeView: view)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func showNewPasswordScreen(_ token: String) {
        let viewModel = NewPasswordViewModel(token: token, coordinator: self)
        let view = NewPasswordView(viewModel: viewModel)
        let viewController = NewPasswordViewController(newPasswordView: view)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func showSuccessScreen() {
        let viewModel = NewPasswordSuccessViewModel(coordinator: self)
        let view = NewPasswordSuccessView(viewModel: viewModel)
        let controller = NewPasswordSuccessViewController(view: view)
        navigationController.pushViewController(controller, animated: true)
    }
    
    func popToLoginVC() {
        if let loginVC {
            navigationController.popToViewController(loginVC, animated: true)
        }
    }
}
