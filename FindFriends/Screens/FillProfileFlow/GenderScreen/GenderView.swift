//
//  GenderView.swift
//  FindFriends
//
//  Created by Ognerub on 3/4/24.
//

import UIKit
import Combine

final class GenderView: UIView {
    private let viewModel: GenderViewModel
    
    private var mainLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = UIColor(named: "primeDark")
        label.font = .medium24
        label.text = "Ваш пол"
        return label
    }()
    
    private var mainInfoText: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = UIColor(named: "primeDark")
        label.numberOfLines = 2
        label.lineBreakMode = .byWordWrapping
        label.font = .regular16
        label.text = "Влияет на события, \n которые Вам будут доступны"
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.spacing = 52
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        return stack
    }()
    
    private lazy var genderManImageView: UIImageView = UIImageView(image: .genderMan)
    private lazy var genderWomanImageView: UIImageView = UIImageView(image: .genderWoman)
    private let genderManButton = GenderSelectionButton(text: "Мужской")
    private let genderWomanButton = GenderSelectionButton(text: "Женский")
    
    private let nextButton = PrimeOrangeButton(text: "Продолжить")
    private var cancellables: Set<AnyCancellable> = []
    
    init(viewModel: GenderViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        
        setupViews()
        setupLayout()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension GenderView {
    func bind() {
        viewModel.$selectedGender
            .sink { [weak self] gender in
                if gender != nil {
                    self?.nextButton.isEnabled = true
                    self?.nextButton.backgroundColor = .mainOrange
                    switch gender {
                    case .man:
                        self?.isManSelected(true)
                    case .woman:
                        self?.isManSelected(false)
                    default:
                        return
                    }
                } else {
                    self?.nextButton.backgroundColor = .lightOrange
                }
            }
            .store(in: &cancellables)
    }
    
    @objc
    private func genderManSelected() {
        viewModel.change(gender: .man)
    }
    @objc
    private func genderWomanSelected() {
        viewModel.change(gender: .woman)
    }
    private func isManSelected(_ bool: Bool) {
        genderManButton.isSelected(bool ? true : false)
        genderWomanButton.isSelected(bool ? false : true)
    }
    
    @objc
    private func nextButtonTap() {
        viewModel.nextButtonTapped()
    }
    
    func setupViews() {
        backgroundColor = .white
        genderWomanButton.addTarget(self, action: #selector(genderWomanSelected), for: .touchUpInside)
        genderManButton.addTarget(self, action: #selector(genderManSelected), for: .touchUpInside)
        
        nextButton.isEnabled = false
        nextButton.addTarget(self, action: #selector(nextButtonTap), for: .touchUpInside)
    }
    
    func setupLayout() {
        addSubviewWithoutAutoresizingMask(mainLabel)
        addSubviewWithoutAutoresizingMask(mainInfoText)
        addSubviewWithoutAutoresizingMask(nextButton)
        addSubviewWithoutAutoresizingMask(stackView)
        stackView.addArrangedSubview(genderWomanButton)
        genderWomanButton.addSubviewWithoutAutoresizingMask(genderWomanImageView)
        stackView.addArrangedSubview(genderManButton)
        genderManButton.addSubviewWithoutAutoresizingMask(genderManImageView)
        
        NSLayoutConstraint.activate([
            mainLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            mainLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            mainLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 36),
            mainLabel.heightAnchor.constraint(equalToConstant: 41),
            
            mainInfoText.topAnchor.constraint(equalTo: mainLabel.bottomAnchor),
            mainInfoText.leadingAnchor.constraint(equalTo: leadingAnchor),
            mainInfoText.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            nextButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            nextButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            nextButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -102),
            nextButton.heightAnchor.constraint(equalToConstant: 48),
            
            stackView.topAnchor.constraint(equalTo: mainInfoText.bottomAnchor, constant: 74),
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            stackView.heightAnchor.constraint(equalToConstant: 122),
            
            genderWomanButton.widthAnchor.constraint(equalToConstant: 97),
            genderWomanButton.heightAnchor.constraint(equalToConstant: 122),
            genderWomanImageView.centerXAnchor.constraint(equalTo: genderWomanButton.centerXAnchor),
            genderWomanImageView.topAnchor.constraint(equalTo: genderWomanButton.topAnchor, constant: 5),
            
            genderManButton.widthAnchor.constraint(equalToConstant: 97),
            genderWomanButton.heightAnchor.constraint(equalToConstant: 122),
            genderManImageView.centerXAnchor.constraint(equalTo: genderManButton.centerXAnchor),
            genderManImageView.topAnchor.constraint(equalTo: genderManButton.topAnchor, constant: 5)
        ])
    }
}

