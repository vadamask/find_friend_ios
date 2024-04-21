import SafariServices
import UIKit

final class RegistrationViewController: BaseRegistrationViewController {
    private var registrationView: RegistrationView

    override func loadView() {
        self.view = registrationView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Регистрация"
    }
    
    init(registrationView: RegistrationView) {
        self.registrationView = registrationView
        super.init(baseRegistrationView: registrationView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
