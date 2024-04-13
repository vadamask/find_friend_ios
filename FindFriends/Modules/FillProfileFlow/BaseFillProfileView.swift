//
//  BaseFillProfileView.swift
//  FindFriends
//
//  Created by Vitaly on 04.03.2024.
//

import UIKit

class BaseFillProfileView: UIView {
    
    lazy var screenHeader: UILabel = {
        let label = UILabel()
        label.font = .medium24
        label.textColor = .primeDark
        return label
    }()
    
    lazy var screenSubheader: UILabel = {
        let label = UILabel()
        label.font = .regular16
        label.textColor = .standardGreyWireframe
        label.numberOfLines = 2
        label.textAlignment = .center
        return label
    }()
    
    lazy var nextButton = PrimeOrangeButton(text: "Продолжить")
    
    lazy var passButton: UIButton = {
        var button = UIButton()
        button.setTitle("Пропустить", for: .normal)
        button.titleLabel?.font = .semibold17
        button.setTitleColor(.buttonBlack, for: .normal)
        return button
    }()
    
    init(header: String, subheader: String = "", passButtonHidden: Bool) {
        super.init(frame: .zero)
    
        backgroundColor = .white
        screenHeader.text = header
        screenSubheader.text = subheader
        passButton.isHidden = passButtonHidden
        setConstraits()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setConstraits() {
        self.addSubviewWithoutAutoresizingMask(screenHeader)
        self.addSubviewWithoutAutoresizingMask(nextButton)
        self.addSubviewWithoutAutoresizingMask(passButton)
        
        if screenSubheader.text?.isEmpty != nil  {
            self.addSubviewWithoutAutoresizingMask(screenSubheader)
            NSLayoutConstraint.activate([
                screenSubheader.topAnchor.constraint(equalTo: screenHeader.bottomAnchor),
                screenSubheader.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 46.5),
                screenSubheader.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -46.5)
            ])
        }
        
        NSLayoutConstraint.activate([
            screenHeader.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            screenHeader.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 36),
            screenHeader.heightAnchor.constraint(equalToConstant: 41),
            
            nextButton.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -64),
            nextButton.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            nextButton.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            nextButton.heightAnchor.constraint(equalToConstant: 48),
            
            passButton.topAnchor.constraint(equalTo: nextButton.bottomAnchor, constant: 16),
            passButton.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 125.5),
            passButton.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -125.5),
            passButton.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
}
