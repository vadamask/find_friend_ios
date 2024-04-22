import UIKit

final class LoginViewController: BaseAuthViewController {

    private let loginView: LoginView

    init(loginView: LoginView) {
        self.loginView = loginView
        super.init(baseRegistrationView: loginView)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        self.view = loginView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Вход"
        navigationItem.backButtonTitle = "Назад"
        navigationItem.hidesBackButton = true
    }
}
