//
//  AuthCoordinator.swift
//  FindFriends
//
//  Created by Вадим Шишков on 13.04.2024.
//

import UIKit

protocol AuthCoordinatorProtocol: Coordinator {
    func showRegistrationScreen()
    func showResetPasswordScreen()
    func showMainFlow()
}

final class AuthCoordinator: AuthCoordinatorProtocol {
    var navigationController: UINavigationController
    weak var parent: Coordinator?
    var childs: [Coordinator] = []
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewModel = LoginViewModel(coordinator: self)
        let view = LoginView(viewModel: viewModel)
        let viewController = LoginViewController(loginView: view)
        self.navigationController.navigationItem.backButtonTitle = nil
        navigationController.pushViewController(viewController, animated: false)
    }
    
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
    
    func showResetPasswordScreen() {
        let 
    }
    
    func showMainFlow() {
        navigationController.dismiss(animated: true)
    }
    
    func showAlert(_ message: String) {
        AlertPresenter.show(in: navigationController, model: AlertModel(message: message))
    }
}
