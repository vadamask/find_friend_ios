//
//  LoginViewController.swift
//  FindFriends
//
//  Created by Artem Novikov on 20.02.2024.
//

import UIKit

final class LoginViewController: UIViewController {

    private let loginView: LoginView

    init(loginView: LoginView) {
        self.loginView = loginView
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        self.view = loginView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Вход"
        navigationItem.backButtonTitle = "Назад"
        navigationItem.hidesBackButton = true
    }
}
