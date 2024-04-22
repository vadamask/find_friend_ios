import UIKit

final class EnterVerificationCodeViewController: BaseAuthViewController {
    private let enterVerficationCodeView: EnterVerificationCodeView
    
    override func loadView() {
        self.view = enterVerficationCodeView
    }
    
    init(enterVerficationCodeView: EnterVerificationCodeView) {
        self.enterVerficationCodeView = enterVerficationCodeView
        super.init(baseRegistrationView: enterVerficationCodeView)
        setupNavigationItem()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupNavigationItem() {
        navigationItem.title = "Верификация"
        navigationItem.backButtonTitle = "Назад"
    }
}
