import UIKit

final class EnterVerificationCodeViewController: BaseRegistrationViewController {
    private let enterVerficationCodeView: EnterVerificationCodeView
    
    override func loadView() {
        self.view = enterVerficationCodeView
    }
    
    init(enterVerficationCodeView: EnterVerificationCodeView) {
        self.enterVerficationCodeView = enterVerficationCodeView
        super.init(baseRegistrationView: BaseRegistrationView())
        
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
