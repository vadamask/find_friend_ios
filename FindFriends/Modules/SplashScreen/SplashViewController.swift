import UIKit

final class SplashViewController: UIViewController {
    
    private let splashView: SplashView
    
    init(splashView: SplashView) {
        self.splashView = splashView
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = splashView
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        splashView.viewDidAppear()
    }
}
