import UIKit

final class BirthdayViewController: UIViewController {
    var birthdayView: BirthdayView
    
    override func loadView() {
        view = birthdayView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
    }
    
    init(birthdayView: BirthdayView) {
        self.birthdayView = birthdayView
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
