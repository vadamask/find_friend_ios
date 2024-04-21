import UIKit

final class NewPasswordSuccessViewController: UIViewController {
    private let newPasswordSuccessView: NewPasswordSuccessView
    
    init(view: NewPasswordSuccessView) {
        self.newPasswordSuccessView = view
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = newPasswordSuccessView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
    }

    private func configureNavigationBar() {
        navigationItem.setHidesBackButton(true, animated: false)
    }
}
