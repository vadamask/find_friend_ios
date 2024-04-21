import UIKit

final class GenderViewController: UIViewController {
    var genderView: GenderView
    
    init(genderView: GenderView) {
        self.genderView = genderView
        super.init(nibName: "GenderSelectionViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = genderView
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

