import Combine
import UIKit

protocol SelectCityViewDelegate: AnyObject {
    func showCityScreen(_ viewModel: SelectCityViewModel)
}

final class SelectCityView: BaseFillProfileView {
    weak var delegate: SelectCityViewDelegate?
    private let viewModel: SelectCityViewModel
    private var cancellables: Set<AnyCancellable> = []
    
    private lazy var searchCityTextField: SearchBar = {
        let textField = SearchBar()
        textField.placeholder = "Поиск по названию"
        textField.delegate = self
        textField.searchTextField.addTarget(self, action: #selector(didTapSearchCityText), for: .allTouchEvents)
        return textField
    }()
    
    init(viewModel: SelectCityViewModel) {
        self.viewModel = viewModel
        super.init(
            header: "Выберите город",
            subheader: "Чтобы видеть события и друзей",
            passButtonHidden: false
        )
        setupLayout()
        bind()
        nextButton.addTarget(self, action: #selector(didTapContinueButton), for: .touchUpInside)
        passButton.addTarget(self, action: #selector(didTapSkipButton), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind() {
        viewModel.$selectCity
            .sink { [unowned self] city in
                if let city {
                    searchCityTextField.text = city.name
                    nextButton.setEnabled(true)
                } else {
                    nextButton.setEnabled(false)
                }
            }
            .store(in: &cancellables)
    }
    
    private func setupLayout() {
        addSubviewWithoutAutoresizingMask(searchCityTextField)
        
        NSLayoutConstraint.activate([
            searchCityTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            searchCityTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            searchCityTextField.topAnchor.constraint(equalTo: screenSubheader.bottomAnchor, constant: 20),
            searchCityTextField.heightAnchor.constraint(equalToConstant: 36)
        ])
    }
    
    @objc private func didTapContinueButton() {
        viewModel.nextButtonTapped()
    }
    
    @objc private func didTapSkipButton() {
        viewModel.skipButtonTapped()
    }
    
    @objc private func didTapSearchCityText() {
        delegate?.showCityScreen(viewModel)
    }
}

// MARK: - UISearchBarDelegate

extension SelectCityView: UISearchBarDelegate {
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        return false
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            viewModel.cancelButtonClicked()
        }
    }
}
