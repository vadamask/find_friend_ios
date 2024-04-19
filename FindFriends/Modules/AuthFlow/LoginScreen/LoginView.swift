import Combine
import SnapKit
import UIKit

final class LoginView: BaseRegistrationView {

    private enum Constants {
        static let bigCircleWidth: CGFloat = 184
        static let smallCirclewidth: CGFloat = 133
        static let elementHeight: CGFloat = 48
    }
    
    private var viewModel: LoginViewModel
    private var cancellables: Set<AnyCancellable> = []
    
    private let bigCircleView: UIView = CircleView(
        cornerRadius: Constants.bigCircleWidth / 2
    )
    private let smallCircleView: UIView = CircleView(
        cornerRadius: Constants.smallCirclewidth / 2
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
            .sink { [unowned self] isLoading in
                if isLoading {
                    loadingIndicator.show()
                } else {
                    loadingIndicator.hide()
                }
            }
            .store(in: &cancellables)
    }
    
    private func setupViews() {
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
            for: .editingChanged
        )
        passwordTextField.addTarget(
            self,
            action: #selector(passwordTextFieldDidChanged),
            for: .editingChanged
        )
    }

    private func setupLayout() {
        contentView.addSubview(bigCircleView)
        contentView.addSubview(smallCircleView)
        contentView.addSubview(emailTextField)
        contentView.addSubview(passwordTextField)
        contentView.addSubview(logInButton)
        contentView.addSubview(registrationButton)
        contentView.addSubview(forgotPasswordButton)
        
        bigCircleView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: Constants.bigCircleWidth, height: Constants.bigCircleWidth))
            make.top.equalTo(topDecoration.snp.bottom).offset(-33)
            make.trailing.equalToSuperview().offset(48)
        }
        
        emailTextField.snp.makeConstraints { make in
            make.leading.trailing.equalTo(layoutMarginsGuide)
            make.height.equalTo(Constants.elementHeight)
            make.top.equalTo(bigCircleView.snp.bottom).offset(4)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.leading.trailing.equalTo(layoutMarginsGuide)
            make.height.equalTo(Constants.elementHeight)
            make.top.equalTo(emailTextField.snp.bottom).offset(24)
        }
        
        forgotPasswordButton.snp.makeConstraints { make in
            make.trailing.equalTo(layoutMarginsGuide)
            make.height.equalTo(Constants.elementHeight)
            make.top.equalTo(passwordTextField.snp.bottom).offset(4)
        }
        
        smallCircleView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: Constants.smallCirclewidth, height: Constants.smallCirclewidth))
            make.bottom.equalTo(logInButton.snp.top).offset(-32)
            make.leading.equalToSuperview().offset(-33)
        }
        
        logInButton.snp.makeConstraints { make in
            make.leading.trailing.equalTo(layoutMarginsGuide)
            make.height.equalTo(Constants.elementHeight)
            make.bottom.equalTo(registrationButton.snp.top).offset(-16)
        }
        
        registrationButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 148, height: Constants.elementHeight))
            make.bottom.equalTo(contentView.safeAreaLayoutGuide).offset(-21)
        }
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
        viewModel.email.value = text
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
