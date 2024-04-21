import Foundation

final class NewPasswordSuccessViewModel {
    private let coordinator: AuthCoordinatorProtocol
    
    init(coordinator: AuthCoordinatorProtocol) {
        self.coordinator = coordinator
    }
    
    func didTapLogInButton() {
        coordinator.popToLoginVC()
    }
}
