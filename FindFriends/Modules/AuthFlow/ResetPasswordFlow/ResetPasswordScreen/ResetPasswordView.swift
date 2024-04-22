import Combine
import SnapKit
import UIKit

final class ResetPasswordView: BaseAuthView {

    private enum Constants {
        static let height: CGFloat = 48
    }
    
    private let viewModel: ResetPasswordViewModel
    private var cancellables: Set<AnyCancellable> = []
    
    private let label: UILabel = {
        let label = UILabel()
        label.textColor = .primeDark
        label.numberOfLines = 0
        label.font = .regular17
        label.text = "Укажите электронную почту, связанную с вашей учетной записью. " +
                     "Мы отправим вам письмо с кодом для сброса пароля."
        return label
    }()
    
    private let emailTextField = RegistrationTextField(
        placeholder: "Электронная почта", type: .email
    )

    init(viewModel: ResetPasswordViewModel) {
        self.viewModel = viewModel
        super.init(primeButton: "Отправить код")
        setupViews()
        setupLayout()
        bind()
        emailTextField.delegate = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind() {
        viewModel.$emailIsEmpty
            .sink { [unowned self] isEmpty in
                primeButton.setEnabled(!isEmpty)
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
        primeButton.addTarget(
            self,
            action: #selector(sendCodeTapped),
            for: .touchUpInside
        )
        emailTextField.addTarget(
            self,
            action: #selector(textFieldChanged),
            for: .editingChanged
        )
    }

    private func setupLayout() {
        scrollView.addSubview(label)
        scrollView.addSubview(emailTextField)
        
        label.snp.makeConstraints { make in
            make.leading.trailing.equalTo(layoutMarginsGuide)
            make.top.equalTo(topDecoration.snp.bottom).offset(32)
        }
        
        emailTextField.snp.makeConstraints { make in
            make.leading.trailing.equalTo(layoutMarginsGuide)
            make.height.equalTo(Constants.height)
            make.top.equalTo(label.snp.bottom).offset(12)
        }
    }

    @objc private func sendCodeTapped() {
        viewModel.sendCodeTapped()
    }

    @objc private func textFieldChanged() {
        guard let text = emailTextField.text else { return }
        viewModel.email.send(text)
    }
}


// MARK: - UITextFieldDelegate

extension ResetPasswordView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        endEditing(true)
        return true
    }
}
