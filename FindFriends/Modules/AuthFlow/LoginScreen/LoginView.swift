//
//  LoginView.swift
//  FindFriends
//
//  Created by Artem Novikov on 20.02.2024.
//

import Combine
import UIKit

final class LoginView: BaseRegistrationView {

    private enum Constants {
        enum BigCircle {
            static let width: CGFloat = 184
            static let trailingInset: CGFloat = 48
            static let topInset: CGFloat = 33
        }
        enum SmallCircle {
            static let width: CGFloat = 133
            static let leadingInset: CGFloat = 33
            static let bottomInset: CGFloat = 33
        }
    }
    
    private var viewModel: LoginViewModel
    private var cancellables: Set<AnyCancellable> = []
    
    private let bigCircleView: UIView = CircleView(
        cornerRadius: Constants.BigCircle.width / 2
    )
    private let smallCircleView: UIView = CircleView(
        cornerRadius: Constants.SmallCircle.width / 2
    )
    private let emailTextField = RegistrationTextField(
        placeholder: "Электронная почта", type: .email
    )
    private let passwordTextField = RegistrationTextField(
        placeholder: "Пароль", type: .password
    )
    private let logInButton = PrimeOrangeButton(text: "Войти")
    private let registrationButton = CaptionButton(text: "Регистрация")
    private let forgotPasswordButton = UnderlinedButton(text: "Забыли пароль?")

    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        setupViews()
        setupLayout()
        bind()
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind() {
        viewModel.$emptyFields
            .sink { [unowned self] isEmpty in
                logInButton.setEnabled(!isEmpty)
            }
            .store(in: &cancellables)
        
        viewModel.$emailError
            .sink { [unowned self] error in
                if let error {
                    emailTextField.showWarningLabel(error)
                } else {
                    emailTextField.hideWarningLabel()
                }
            }
            .store(in: &cancellables)
        
        viewModel.$isLoading
            .sink { isLoading in
                if isLoading {
                    UIBlockingProgressHUD.show()
                } else {
                    UIBlockingProgressHUD.dismiss()
                }
            }
            .store(in: &cancellables)
    }
    
    private func setupViews() {
        contentView.addSubviewWithoutAutoresizingMask(bigCircleView)
        contentView.addSubviewWithoutAutoresizingMask(smallCircleView)
        contentView.addSubviewWithoutAutoresizingMask(emailTextField)
        contentView.addSubviewWithoutAutoresizingMask(passwordTextField)
        contentView.addSubviewWithoutAutoresizingMask(logInButton)
        contentView.addSubviewWithoutAutoresizingMask(registrationButton)
        contentView.addSubviewWithoutAutoresizingMask(forgotPasswordButton)

        logInButton.addTarget(
            self,
            action: #selector(loginButtonTapped),
            for: .touchUpInside
        )
        registrationButton.addTarget(
            self,
            action: #selector(registrationButtonTapped),
            for: .touchUpInside
        )
        forgotPasswordButton.addTarget(
            self,
            action: #selector(forgotPasswordButtonTapped),
            for: .touchUpInside
        )
        emailTextField.addTarget(
            self,
            action: #selector(emailTextFieldDidChanged),
            for: .valueChanged
        )
        passwordTextField.addTarget(
                self,
                action: #selector(passwordTextFieldDidChanged),
                for: .editingChanged
        )
    }

    private func setupLayout() {
        NSLayoutConstraint.activate([
            bigCircleView.widthAnchor.constraint(equalToConstant: Constants.BigCircle.width),
            bigCircleView.heightAnchor.constraint(equalToConstant: Constants.BigCircle.width),
            topDecoration.bottomAnchor.constraint(equalTo: bigCircleView.topAnchor, constant: Constants.BigCircle.topInset),
            bigCircleView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: Constants.BigCircle.trailingInset),

            emailTextField.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            emailTextField.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
            emailTextField.heightAnchor.constraint(equalToConstant: 48),
            contentView.centerYAnchor.constraint(equalTo: emailTextField.centerYAnchor, constant: 36),

            passwordTextField.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            passwordTextField.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
            passwordTextField.heightAnchor.constraint(equalTo: emailTextField.heightAnchor),
            passwordTextField.heightAnchor.constraint(equalToConstant: 48),
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 24),

            forgotPasswordButton.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
            forgotPasswordButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 4),
            forgotPasswordButton.heightAnchor.constraint(equalToConstant: 48),

            smallCircleView.widthAnchor.constraint(equalToConstant: Constants.SmallCircle.width),
            smallCircleView.heightAnchor.constraint(equalToConstant: Constants.SmallCircle.width),
            logInButton.topAnchor.constraint(equalTo: smallCircleView.bottomAnchor, constant: Constants.SmallCircle.bottomInset),
            leadingAnchor.constraint(equalTo: smallCircleView.leadingAnchor, constant: Constants.SmallCircle.leadingInset),

            logInButton.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            logInButton.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
            logInButton.heightAnchor.constraint(equalToConstant: 48),
            
            registrationButton.topAnchor.constraint(equalTo: logInButton.bottomAnchor, constant: 16),
            registrationButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            registrationButton.heightAnchor.constraint(equalToConstant: 48),
            contentView.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: registrationButton.bottomAnchor, constant: 21)
        ])
    }

    @objc private func loginButtonTapped() {
        viewModel.didTapLoginButton()
    }

    @objc private func registrationButtonTapped() {
        viewModel.didTapRegistrationButton()
    }

    @objc private func forgotPasswordButtonTapped() {
        viewModel.didTapForgotPasswordButton()
    }

    @objc private func emailTextFieldDidChanged() {
        guard let text = emailTextField.text else { return }
        viewModel.email.send(text)
    }
    
    @objc private func passwordTextFieldDidChanged() {
        guard let text = passwordTextField.text else { return }
        viewModel.password.send(text)
    }
}

// MARK: - UITextFieldDelegate

extension LoginView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            textField.resignFirstResponder()
            passwordTextField.becomeFirstResponder()
        } else {
            endEditing(true)
        }
        return false
    }
}

// MARK: - CircleView

fileprivate class CircleView: UIView {
    init(cornerRadius: CGFloat) {
        super.init(frame: .zero)
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = true
        backgroundColor = .mainOrange.withAlphaComponent(0.2)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UnderlinedButton

fileprivate class UnderlinedButton: UIButton {
    init(text: String) {
        super.init(frame: .zero)
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.semibold15,
            .foregroundColor: UIColor.primeDark,
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]
        let attributeString = NSMutableAttributedString(
            string: text,
            attributes: attributes
        )
        titleLabel?.font = .regular12
        setAttributedTitle(attributeString, for: .normal)
        backgroundColor = .clear
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
