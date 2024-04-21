import Combine
import UIKit

final class ResetPasswordView: BaseRegistrationView {

    private enum Constants {
        enum Label {
            static let topInset: CGFloat = 32
        }
        enum TextField {
            static let height: CGFloat = 48
            static let topInset: CGFloat = 12
        }
        enum Button {
            static let height: CGFloat = 48
            static let bottomInset: CGFloat = 85
        }
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
    
    private let sendCodeButton = PrimeOrangeButton(text: "Отправить код")

    init(viewModel: ResetPasswordViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
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
                sendCodeButton.setEnabled(!isEmpty)
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
        contentView.addSubviewWithoutAutoresizingMask(label)
        contentView.addSubviewWithoutAutoresizingMask(emailTextField)
        contentView.addSubviewWithoutAutoresizingMask(sendCodeButton)

        sendCodeButton.addTarget(
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
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
            label.topAnchor.constraint(equalTo: topDecoration.bottomAnchor, constant: Constants.Label.topInset),

            emailTextField.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            emailTextField.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
            emailTextField.heightAnchor.constraint(equalToConstant: Constants.TextField.height),
            emailTextField.topAnchor.constraint(equalTo: label.bottomAnchor, constant: Constants.TextField.topInset),

            sendCodeButton.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            sendCodeButton.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
            sendCodeButton.heightAnchor.constraint(equalToConstant: Constants.Button.height),
            contentView.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: sendCodeButton.bottomAnchor, constant: Constants.Button.bottomInset)
        ])
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
