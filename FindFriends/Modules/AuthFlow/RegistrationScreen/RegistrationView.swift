import Combine
import SnapKit
import UIKit

final class RegistrationView: BaseRegistrationView {
    
    private enum Constants {
        static let height = 48
        static let spacing = 24
    }
    
    private let viewModel: RegistrationViewModel
    private let registrationButton = PrimeOrangeButton(text: "Зарегистрироваться")
    private var cancellables: Set<AnyCancellable> = []
    
    private lazy var nameTextField: RegistrationTextField = {
        let textField = RegistrationTextField( placeholder: "Имя", type: .name)
        textField.addTarget(self, action: #selector(nameDidChange), for: .editingChanged)
        return textField
    }()
    
    private lazy var lastnameTextField: RegistrationTextField = {
        let textField = RegistrationTextField(placeholder: "Фамилия", type: .lastName)
        textField.addTarget(self, action: #selector(lastNameDidChange), for: .editingChanged)
        return textField
    }()
    
    private lazy var emailTextField: RegistrationTextField = {
        let textField = RegistrationTextField(placeholder: "Электронная почта", type: .email)
        textField.addTarget(self, action: #selector(emailDidChange), for: .editingChanged)
        return textField
    }()
    
    private lazy var passwordTextField: RegistrationTextField = {
        let textField = RegistrationTextField(placeholder: "Пароль", type: .password)
        textField.addTarget(self, action: #selector(passwordDidChange), for: .editingChanged)
        return textField
    }()  
    
    private lazy var passwordConfirmationTextField: RegistrationTextField = {
        let textField = RegistrationTextField(placeholder: "Повторите пароль", type: .confirmPassword)
        textField.addTarget(self, action: #selector(confirmPasswordDidChange), for: .editingChanged)
        return textField
    }()
    
    private lazy var agreementLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(agreementDidTapped)))
        
        let text = NSMutableAttributedString(
            string: "Создавая учетную запись, вы принимаете\nУсловия использования"
        )
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        
        text.addAttributes(
            [
                .font: UIFont.systemFont(ofSize: 13, weight: .regular),
                .foregroundColor: UIColor.primeDark,
                .paragraphStyle: paragraphStyle
            ],
            range: NSRange(location: 0, length: text.length)
        )
        
        text.addAttribute(.underlineStyle, value: 1, range: NSRange(location: 39, length: 21))
        label.attributedText = text
        return label
    }()
    
    init(viewModel: RegistrationViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        setupViews()
        setupLayout()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind() {
        
        viewModel.$allFieldsAreFilling
            .sink { [weak self] isFilling in
                self?.registrationButton.setEnabled(isFilling)
            }
            .store(in: &cancellables)
        
        viewModel.$errorTextForName
            .sink { [unowned self] error in
                if error.isEmpty {
                    nameTextField.hideWarningLabel()
                } else {
                    nameTextField.showWarningLabel(error)
                }
            }
            .store(in: &cancellables) 
        
        viewModel.$errorTextForLastName
            .sink { [unowned self] error in
                if error.isEmpty {
                    lastnameTextField.hideWarningLabel()
                } else {
                    lastnameTextField.showWarningLabel(error)
                }
            }
            .store(in: &cancellables) 
        
        viewModel.$errorTextForEmail
            .sink { [unowned self] error in
                if error.isEmpty {
                    emailTextField.hideWarningLabel()
                } else {
                    emailTextField.showWarningLabel(error)
                }
            }
            .store(in: &cancellables)
        
        viewModel.$errorTextForPassword
            .sink { [unowned self] error in
                if error.isEmpty {
                    passwordTextField.hideWarningLabel()
                } else {
                    passwordTextField.showWarningLabel(error)
                }
            }
            .store(in: &cancellables)
        
        viewModel.$errorTextForConfirmPassword
            .sink { [unowned self] error in
                if error.isEmpty {
                    passwordConfirmationTextField.hideWarningLabel()
                } else {
                    passwordConfirmationTextField.showWarningLabel(error)
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
        backgroundColor = .white
        
        nameTextField.delegate = self
        lastnameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        passwordConfirmationTextField.delegate = self
        
        registrationButton
            .addTarget(
                self,
                action: #selector(registrationButtonTapped),
                for: .touchUpInside
            )
    }
    
    private func setupLayout() {
        contentView.addSubview(nameTextField)
        contentView.addSubview(lastnameTextField)
        contentView.addSubview(emailTextField)
        contentView.addSubview(passwordTextField)
        contentView.addSubview(passwordConfirmationTextField)
        contentView.addSubview(agreementLabel)
        contentView.addSubview(registrationButton)
        
        nameTextField.snp.makeConstraints { make in
            make.leading.trailing.equalTo(layoutMarginsGuide)
            make.top.equalTo(topDecoration.snp.bottom).offset(32)
            make.height.equalTo(Constants.height)
        }
        
        lastnameTextField.snp.makeConstraints { make in
            make.leading.trailing.equalTo(layoutMarginsGuide)
            make.top.equalTo(nameTextField.snp.bottom).offset(Constants.spacing)
            make.height.equalTo(Constants.height)
        } 
        
        emailTextField.snp.makeConstraints { make in
            make.leading.trailing.equalTo(layoutMarginsGuide)
            make.top.equalTo(lastnameTextField.snp.bottom).offset(Constants.spacing)
            make.height.equalTo(Constants.height)
        } 
        
        passwordTextField.snp.makeConstraints { make in
            make.leading.trailing.equalTo(layoutMarginsGuide)
            make.top.equalTo(emailTextField.snp.bottom).offset(Constants.spacing)
            make.height.equalTo(Constants.height)
        }
        
        passwordConfirmationTextField.snp.makeConstraints { make in
            make.leading.trailing.equalTo(layoutMarginsGuide)
            make.top.equalTo(passwordTextField.snp.bottom).offset(Constants.spacing)
            make.height.equalTo(Constants.height)
        }
        
        agreementLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(passwordConfirmationTextField.snp.bottom).offset(74)
        }
      
        registrationButton.snp.makeConstraints { make in
            make.leading.trailing.equalTo(layoutMarginsGuide)
            make.height.equalTo(Constants.height)
            make.top.equalTo(agreementLabel.snp.bottom).offset(16)
        }
    }
}

extension RegistrationView {
    
    @objc private func nameDidChange() {
        guard let name = nameTextField.text else { return }
        viewModel.name = name
        if name.isEmpty {
            nameTextField.hideWarningLabel()
        }
    }
    @objc private func lastNameDidChange() {
        guard let lastName = lastnameTextField.text else { return }
        viewModel.lastName = lastName
        if lastName.isEmpty {
            lastnameTextField.hideWarningLabel()
        }
    }
    @objc private func emailDidChange() {
        guard let email = emailTextField.text else { return }
        viewModel.email = email
        if email.isEmpty {
            emailTextField.hideWarningLabel()
        }
    }
    @objc private func passwordDidChange() {
        guard let password = passwordTextField.text else { return }
        viewModel.password = password
        if password.isEmpty {
            passwordTextField.hideWarningLabel()
        }
    }
    @objc private func confirmPasswordDidChange() {
        guard let confirmPassword = passwordConfirmationTextField.text else { return }
        viewModel.confirmPassword = confirmPassword
        if confirmPassword.isEmpty {
            passwordConfirmationTextField.hideWarningLabel()
        }
    }
    
    @objc private func registrationButtonTapped() {
        viewModel.registrationButtonTapped()
    }
    
    @objc private func agreementDidTapped() {
        viewModel.agreementDidTapped()
    }
}

extension RegistrationView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let fields = [
            nameTextField,
            lastnameTextField,
            emailTextField,
            passwordTextField,
            passwordConfirmationTextField
        ] as [UITextField]
        if let index = fields.firstIndex(of: textField) {
            if index < fields.count - 1 {
                let textField = fields[index + 1]
                textField.becomeFirstResponder()
            } else {
                fields[index].resignFirstResponder()
            }
        }
        return true
    }
}
