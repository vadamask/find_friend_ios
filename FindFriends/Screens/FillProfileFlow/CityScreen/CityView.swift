//
//  CityView.swift
//  FindFriends
//
//  Created by Вадим Шишков on 07.04.2024.
//

import Combine
import UIKit

protocol CityViewDelegate: AnyObject {
    func dismiss()
    func acceptCity(_ city: CityResponse)
}

final class CityView: UIView {
    
    weak var delegate: CityViewDelegate?
    private let viewModel: CityViewModel
    private var cancellables: Set<AnyCancellable> = []
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    private lazy var warningLabel: UILabel = {
        let label = UILabel()
        label.font = .regular11
        label.textColor = .warning
        label.text = "Не найдено"
        label.numberOfLines = 0
        label.isHidden = true
        return label
    }()
    
    private lazy var separator: UIView = {
        let view = UIView()
        view.backgroundColor = .customLightGray
        return view
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(SelectCityTableViewCell.self, forCellReuseIdentifier: SelectCityTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.layer.cornerRadius = 16
        tableView.separatorStyle = .none
        tableView.allowsMultipleSelection = false
        return tableView
    }()
    
    private lazy var acceptButton: PrimeOrangeButton = {
        let button = PrimeOrangeButton(text: "Выбрать")
        button.isEnabled = false
        button.addTarget(self, action: #selector(didTapAcceptButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var cancelButton: WhiteBorderButton = {
        let button = WhiteBorderButton(text: "Отменить")
        button.addTarget(self, action: #selector(didTapCancelButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var borderView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.layer.borderWidth = 0.5
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var buttonStackView: UIStackView = {
        let buttonStackView = UIStackView()
        buttonStackView.alignment = .fill
        buttonStackView.distribution = .fillEqually
        buttonStackView.spacing = 8.0
        return buttonStackView
    }()
    
    private lazy var searchCityTextField: SearchBar = {
        let textField = SearchBar()
        textField.searchTextField.addTarget(self, action: #selector(searchCities(_:)), for: .editingChanged)
        return textField
    }()
    
    init(viewModel: CityViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        
        addView()
        applyConstraints()
        setupButtonStack()
        bind()
        backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func viewWillAppear() {
        viewModel.loadCities()
    }
    
    private func setupButtonStack() {
        borderView.addSubview(buttonStackView)
        buttonStackView.addArrangedSubview(cancelButton)
        buttonStackView.addArrangedSubview(acceptButton)
    }
    
    private func bind() {
        viewModel.$visibleCities
            .sink { [unowned self] cities in
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    if cities.isEmpty {
                        self.warningLabel.isHidden = false
                        self.searchCityTextField.layer.borderColor = UIColor.warning.cgColor
                        self.searchCityTextField.layer.borderWidth = 1
                        self.searchCityTextField.searchTextField.textColor = .warning
                    } else {
                        self.warningLabel.isHidden = true
                        self.searchCityTextField.layer.borderColor = UIColor.clear.cgColor
                        self.searchCityTextField.layer.borderWidth = 0
                        self.searchCityTextField.searchTextField.textColor = .black
                    }
                }
            }
            .store(in: &cancellables)
        
        viewModel.$selectCity
            .sink { [unowned self] city in
                acceptButton.setEnabled(city != nil)
            }
            .store(in: &cancellables)
        
        viewModel.acceptCity
            .sink { [unowned self] _ in
                delegate?.acceptCity(viewModel.selectCity!)
            }
            .store(in: &cancellables)
    }
    
    private func addView() {
        [searchCityTextField,
         warningLabel,
         separator,
         tableView,
         acceptButton,
         cancelButton,
         borderView,
         buttonStackView
        ].forEach(addSubviewWithoutAutoresizingMask(_:))
    }
    
    private func applyConstraints() {
        NSLayoutConstraint.activate([
            searchCityTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            searchCityTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            searchCityTextField.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20),
            searchCityTextField.heightAnchor.constraint(equalToConstant: 38),
            warningLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 28),
            warningLabel.topAnchor.constraint(equalTo: searchCityTextField.bottomAnchor, constant: 4),
            separator.leadingAnchor.constraint(equalTo: leadingAnchor),
            separator.trailingAnchor.constraint(equalTo: trailingAnchor),
            separator.topAnchor.constraint(equalTo: warningLabel.bottomAnchor, constant: 4),
            separator.heightAnchor.constraint(equalToConstant: 0.5),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            tableView.topAnchor.constraint(equalTo: separator.bottomAnchor, constant: 20),
            tableView.bottomAnchor.constraint(equalTo: borderView.topAnchor, constant: -2),
            borderView.leadingAnchor.constraint(equalTo: leadingAnchor),
            borderView.trailingAnchor.constraint(equalTo: trailingAnchor),
            borderView.bottomAnchor.constraint(equalTo: bottomAnchor),
            borderView.heightAnchor.constraint(equalToConstant: 140),
            buttonStackView.leadingAnchor.constraint(equalTo: borderView.leadingAnchor, constant: 16),
            buttonStackView.trailingAnchor.constraint(equalTo: borderView.trailingAnchor, constant: -16),
            buttonStackView.bottomAnchor.constraint(equalTo: borderView.bottomAnchor, constant: -60),
            buttonStackView.topAnchor.constraint(equalTo: borderView.topAnchor, constant: 24)
        ])
    }
    
    @objc func searchCities(_ textfield: UITextField) {
        if let searchText = textfield.text {
            viewModel.textDidChanged(searchText)
        }
    }
    
    @objc private func didTapAcceptButton() {
        viewModel.selectButtonTapped()
    }
    
    @objc private func didTapCancelButton() {
        delegate?.dismiss()
    }
}

extension CityView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.visibleCities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: SelectCityTableViewCell.identifier,
            for: indexPath
        ) as? SelectCityTableViewCell else { return UITableViewCell() }
        
        cell.configureCells(name: viewModel.visibleCities[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelectCityAt(indexPath)
    }
}
