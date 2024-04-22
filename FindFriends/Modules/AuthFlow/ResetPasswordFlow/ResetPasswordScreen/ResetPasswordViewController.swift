import UIKit

final class ResetPasswordViewController: BaseAuthViewController {
    
    private let resetPasswordView: ResetPasswordView

    init(resetPasswordView: ResetPasswordView) {
        self.resetPasswordView = resetPasswordView
        super.init(baseRegistrationView: resetPasswordView)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        self.view = resetPasswordView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Сброс пароля"
        navigationItem.backButtonTitle = "Назад"
    }
}


