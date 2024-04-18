//
//  ResetPasswordViewController.swift
//  FindFriends
//
//  Created by Artem Novikov on 21.02.2024.
//

import UIKit

final class ResetPasswordViewController: BaseRegistrationViewController {
    
    private let resetPasswordView: ResetPasswordView

    init(resetPasswordView: ResetPasswordView) {
        self.resetPasswordView = resetPasswordView
        super.init(baseRegistrationView: resetPasswordView)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        self.view = resetPasswordView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Сброс пароля"
        navigationItem.backButtonTitle = "Назад"
    }
}


