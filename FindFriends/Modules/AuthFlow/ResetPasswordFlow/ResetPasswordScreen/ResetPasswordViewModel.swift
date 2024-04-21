import Combine
import Foundation

final class ResetPasswordViewModel {

    @Published var emailIsEmpty = true
    @Published var emailError: String?
    @Published var isLoading = false
    
    var email = CurrentValueSubject<String, Never>("")
    
    private let resetPasswordService: ResetPasswordServiceProtocol
    private let coordinator: AuthCoordinatorProtocol

    init(
        resetPasswordService: ResetPasswordServiceProtocol,
        coordinator: AuthCoordinatorProtocol
    ) {
        self.resetPasswordService = resetPasswordService
        self.coordinator = coordinator
        
        bind()
    }

    func sendCodeTapped() {
        validateEmail()
        if emailError == nil {
            isLoading = true
            resetPasswordService.resetPassword(ResetPasswordRequestDto(email: email.value)) { [unowned self] result in
                switch result {
                case .success(let response):
                    if response.status == "OK" {
                        coordinator.showVerificationCodeScreen(email.value)
                    } else {
                        print("reset password not ok")
                    }
                case .failure(let error):
                    coordinator.showAlert(error.message)
                }
                isLoading = false
            }
        }
    }
    
    private func bind() {
        email
            .map { $0.isEmpty }
            .assign(to: &$emailIsEmpty)
    }

    private func validateEmail() {
        switch ValidationService.validate(email.value, type: .email) {
        case .success:
            emailError = nil
        case .failure(let message):
            emailError = message.rawValue
        }
    }
}
