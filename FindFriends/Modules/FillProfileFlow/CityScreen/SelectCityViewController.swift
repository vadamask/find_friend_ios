import UIKit

final class SelectCityViewController: UIViewController {
    
    private let selectCityView: SelectCityView
    
    init(selectCityView: SelectCityView) {
        self.selectCityView = selectCityView
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = selectCityView
        selectCityView.delegate = self
    }
}

extension SelectCityViewController: SelectCityViewDelegate {
    func showCityScreen(_ viewModel: SelectCityViewModel) {
        if presentedViewController == nil {
            let cityViewModel = CityViewModel()
            let view = CityView(viewModel: cityViewModel)
            let viewController = CityViewController(cityView: view)
            viewController.delegate = viewModel
            
            modalPresentationStyle = .currentContext
            present(viewController, animated: true)
        }
    }
}
