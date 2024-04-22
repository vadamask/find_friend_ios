import Combine
import SnapKit
import UIKit

final class NewPasswordView: BaseAuthView {
    
    private let viewModel: NewPasswordViewModel
    private var cancellables: Set<AnyCancellable> = []

    private let label: UILabel = {
        let label = UILabel()
        label.textColor = .primeDark
        label.numberOfLines = 0
        label.font = .regular17
        label.text = "Придумайте новый пароль. Он должен отличаться от вашего старого пароля."
        return label
    }()
    
    private let passwordTextField = RegistrationTextField(
        placeholder: "Пароль", type: .password
    )
    
    private let passwordConfirmationTextField = RegistrationTextField(
        placeholder: "Повторите пароль", type: .password
    )

    init(viewModel: NewPasswordViewModel) {
        self.viewModel = viewModel
        super.init(primeButton: "Сохранить пароль")
        setupViews()
        setupLayout()
        bind()
        passwordTextField.delegate = self
        passwordConfirmationTextField.delegate = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setPasswordTextFieldError(message: String) {
        setError(for: passwordTextField, message: message)
    }

    func setPasswordConfirmationTextFieldError(message: String) {
        setError(for: passwordConfirmationTextField, message: message)
    }

    private func setError(for textField: RegistrationTextField, message: String) {
        if message.isEmpty {
            textField.hideWarningLabel()
        } else {
            textField.showWarningLabel(message)
        }
    }
    
    private func bind() {
        viewModel.$fieldsAreFilling
            .sink { [unowned self] isFilling in
                primeButton.setEnabled(isFilling)
            }
            .store(in: &cancellables)

        viewModel.$errorForPassword
            .sink { [unowned self] error in
                setPasswordTextFieldError(message: error)
            }
            .store(in: &cancellables)
        
        viewModel.$errorForConfirmPassword
            .sink { [unowned self] error in
                setPasswordConfirmationTextFieldError(message: error)
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
        primeButton.addTarget(
            self,
            action: #selector(savePasswordButtonTapped),
            for: .touchUpInside
        )
        for textField in [passwordTextField, passwordConfirmationTextField] {
            textField.addTarget(
                self,
                action: #selector(textFieldChanged),
                for: .editingChanged
            )
        }
    }

    private func setupLayout() {
        scrollView.addSubview(label)
        scrollView.addSubview(passwordTextField)
        scrollView.addSubview(passwordConfirmationTextField)
        
        label.snp.makeConstraints { make in
            make.top.equalTo(topDecoration.snp.bottom).offset(32)
            make.leading.trailing.equalTo(layoutMarginsGuide)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(label.snp.bottom).offset(16)
            make.height.equalTo(44)
            make.leading.trailing.equalTo(layoutMarginsGuide)
        }
        
        passwordConfirmationTextField.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(24)
            make.leading.trailing.equalTo(layoutMarginsGuide)
            make.height.equalTo(44)
        }
    }

    @objc private func savePasswordButtonTapped() {
        viewModel.saveButtonTapped()
    }

    @objc private func textFieldChanged() {
        viewModel.textFieldsDidChanged(passwordTextField.text, passwordConfirmationTextField.text)
    }
}

// MARK: - UITextFieldDelegate

extension NewPasswordView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == passwordTextField{
            textField.resignFirstResponder()
            passwordConfirmationTextField.becomeFirstResponder()
        } else {
            endEditing(true)
        }
        return false
    }
}
