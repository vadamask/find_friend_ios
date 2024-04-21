import Foundation

final class NewPasswordViewModel {
    @Published var fieldsAreFilling = false
    @Published var errorForPassword = ""
    @Published var errorForConfirmPassword = ""
    @Published var isLoading = false
    var password = ""
    var confirmPassword = ""
    let token: String

    private let resetPasswordService: ResetPasswordServiceProtocol
    private let coordinator: AuthCoordinatorProtocol

    init(
        resetPasswordService: ResetPasswordServiceProtocol = ResetPasswordService(),
        token: String,
        coordinator: AuthCoordinatorProtocol
    ) {
        self.resetPasswordService = resetPasswordService
        self.token = token
        self.coordinator = coordinator
    }
    
    func saveButtonTapped() {
        if validateFields() {
            isLoading = true
            let dto = NewPasswordDto(token: token, password: confirmPassword)
            resetPasswordService.setNewPassword(dto) { [unowned self] result in
                switch result {
                case .success(_):
                    coordinator.showSuccessScreen()
                case .failure(_):
                    coordinator.showAlert("Произошла неизвестная ошибка")
                }
                isLoading = false
            }
        }
    }
    
    func textFieldsDidChanged(_ password: String?,_ confirmPassword: String?) {
        guard let password,
              let confirmPassword else { return }
        self.password = password
        self.confirmPassword = confirmPassword
        fieldsAreFilling = !password.isEmpty && !confirmPassword.isEmpty
    }
    
    private func validateFields() -> Bool {
        let isPasswordValid = validatePassword()
        let isPasswordConfirmationValid = validatePasswordConfirmation()
        return isPasswordValid && isPasswordConfirmationValid
    }

    private func validatePassword() -> Bool {
        switch ValidationService.validate(password, type: .password) {
        case .success:
            errorForPassword = ValidateMessages.emptyMessage.rawValue
            return true
        case .failure(let message):
            errorForPassword = message.rawValue
            return false
        }
    }

    private func validatePasswordConfirmation() -> Bool {
        if password != confirmPassword {
            errorForConfirmPassword = ValidateMessages.passwordsNotEqual.rawValue
            return false
        }
        switch ValidationService.validate(confirmPassword, type: .confirmPassword) {
        case .success(_):
            errorForConfirmPassword = ValidateMessages.emptyMessage.rawValue
            return true
        case .failure(let message):
            errorForConfirmPassword = message.rawValue
            return false
        }
    }
}

