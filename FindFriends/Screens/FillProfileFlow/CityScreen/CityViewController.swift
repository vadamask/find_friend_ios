import UIKit

protocol CityViewControllerDelegate: AnyObject {
    func acceptCity(_ city: CityResponse)
}

final class CityViewController: UIViewController {
    
    private let cityView: CityView
    weak var delegate: CityViewControllerDelegate?
    
    override func loadView() {
        self.view = cityView
        cityView.delegate = self
    }
    
    init(cityView: CityView) {
        self.cityView = cityView
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cityView.viewWillAppear()
    }
}

extension CityViewController: CityViewDelegate {
    func dismiss() {
        dismiss(animated: true)
    }
    
    func acceptCity(_ city: CityResponse) {
        delegate?.acceptCity(city)
        dismiss(animated: true)
    }
}
