import UIKit

final class CityViewController: UIViewController {
    
    private let viewModel: CityViewModel
    
    private lazy var firstLabel: UILabel = {
        let label = UILabel()
        label.font = .medium24
        label.textAlignment = .center
        label.text = "Выберите город"
        return label
    }()
    
    private lazy var secondLabel: UILabel = {
        let label = UILabel()
        label.font = .regular16
        label.textAlignment = .center
        label.text = "Чтобы видеть события и друзей"
        label.textColor = .standardGreyWireframe
        return label
    }()
    
    private lazy var searchCityTextField: SearchBar = {
        let textField = SearchBar()
        textField.placeholder = "Поиск по названию"
        textField.delegate = self
        return textField
    }()
    
    private lazy var continueButton: PrimeOrangeButton = {
        let button = PrimeOrangeButton(text: "Далее")
        button.addTarget(self, action: #selector(didTapContinueButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var skipButton: UIButton = {
        let button = UIButton()
        button.setTitle("Пропустить", for: .normal)
        button.setTitleColor(.buttonBlack, for: .normal)
        button.titleLabel?.font = .semibold17
        button.addTarget(self, action: #selector(didTapSkipButton), for: .touchUpInside)
        return button
    }()
    
    init(viewModel: CityViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        addView()
        applyConstraints()
    }
    
    private func addView() {
        [firstLabel, secondLabel, searchCityTextField, continueButton, skipButton].forEach(view.addSubviewWithoutAutoresizingMask(_:))
    }
    
    private func applyConstraints() {
        NSLayoutConstraint.activate([
            firstLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            firstLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            firstLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 36),
            secondLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            secondLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            secondLabel.topAnchor.constraint(equalTo: firstLabel.bottomAnchor, constant: 10),
            searchCityTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            searchCityTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            searchCityTextField.topAnchor.constraint(equalTo: secondLabel.bottomAnchor, constant: 20),
            searchCityTextField.heightAnchor.constraint(equalToConstant: 36),
            skipButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -38),
            skipButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            skipButton.heightAnchor.constraint(equalToConstant: 48),
            skipButton.widthAnchor.constraint(equalToConstant: 139),
            continueButton.bottomAnchor.constraint(equalTo: skipButton.topAnchor, constant: -10),
            continueButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            continueButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            continueButton.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
    
    private func tapGesture() {
        continueButton.isEnabled = false
        continueButton.backgroundColor = .lightOrange
        searchCityTextField.searchTextField.placeholder = "Поиск по названию"
        searchCityTextField.isUserInteractionEnabled = true
        searchCityTextField.searchTextField.addTarget(self, action: #selector(didTapSearchCityText), for: .allEvents)
    }
    
    @objc private func didTapContinueButton() {
        viewModel.nextButtonTapped()
    }
    
    @objc private func didTapSkipButton() {
        viewModel.skipButtonTapped()
        continueButton.backgroundColor = .lightOrange
        continueButton.isEnabled = false
    }
    
    @objc private func didTapSearchCityText() {
        if presentedViewController == nil {
            let vc = SelectCityViewController(viewModel: viewModel)
            vc.delegate = self
            modalPresentationStyle = .currentContext
            present(vc, animated: true)
        }
    }
}

extension CityViewController: UISearchBarDelegate {
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        tapGesture()
        return false
    }
}

extension CityViewController: ModalViewControllerDelegate {
    func updateSearchTextField(name: String, withDismiss result: Bool) {
        if result {
            searchCityTextField.text = name
            searchCityTextField.searchTextField.placeholder = ""
        } else {
            searchCityTextField.text = ""
            searchCityTextField.searchTextField.placeholder = "Поиск по названию"
        }
    }
    
    func modalControllerWillDisapear(_ model: SelectCityViewController, withDismiss result: Bool) {
        if result {
            continueButton.backgroundColor = .mainOrange
            continueButton.isEnabled = true
        } else {
            continueButton.backgroundColor = .lightOrange
            continueButton.isEnabled = false
        }
    }
}
