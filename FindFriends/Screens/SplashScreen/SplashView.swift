//
//  SplashView.swift
//  FindFriends
//
//  Created by Artem Novikov on 26.02.2024.
//

import Combine
import UIKit

protocol SplashViewDelegate: AnyObject {
    func presentMainFlow()
    func presentLoginFlow()
    func presentFillingFlow()
}

final class SplashView: UIView {

    weak var delegate: SplashViewDelegate?
    
    private enum Constants {
        static let width: CGFloat = 137
        static let height: CGFloat = 139
        static let centerYInset: CGFloat = -72
    }
    
    private let viewModel: SplashViewModel
    private var cancellables: Set<AnyCancellable> = []

    private var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .welcomeLogo
        return imageView
    }()

    private let label: UILabel = {
        let label = UILabel()
        label.textColor = .primeDark
        label.font = UIFont(name: "Montserrat-SemiBold", size: 20)
        return label
    }()
    
    init(viewModel: SplashViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        setupViews()
        setupLayout()
        bind()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func viewDidAppear() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.viewModel.viewDidAppear()
        }
    }

    private func setupViews() {
        backgroundColor = .backgroundLaunchScreen
    }

    private func setupLayout() {
        addSubviewWithoutAutoresizingMask(logoImageView)
        addSubviewWithoutAutoresizingMask(label)
        
        NSLayoutConstraint.activate([
            logoImageView.widthAnchor.constraint(equalToConstant: Constants.width),
            logoImageView.heightAnchor.constraint(equalToConstant: Constants.height),
            logoImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: Constants.centerYInset),
            
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            label.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 20)
        ])
    }
    
    private func bind() {
        viewModel.state
            .sink { [unowned self] state in
                switch state {
                case .login:
                    animateWelcomeViewEntrance()
                case .unlogin:
                    delegate?.presentLoginFlow()
                case .unfinishedRegistration:
                    delegate?.presentFillingFlow()
                }
            }
            .store(in: &cancellables)
        
        viewModel.username
            .sink { [unowned self] name in
                DispatchQueue.main.async {
                    self.label.text = "Привет, \(name)!"
                }
            }
            .store(in: &cancellables)
    }
}

// MARK: - Animations

extension SplashView {
    
    private func animateWelcomeViewEntrance() {
        DispatchQueue.main.async {
            self.label.transform = CGAffineTransform(translationX: 0, y: 50)
            self.label.alpha = 0
            UIView.animate(
                withDuration: 2,
                delay: 0.3,
                usingSpringWithDamping: 0.8,
                initialSpringVelocity: 0,
                options: .curveEaseOut) {
                    self.label.alpha = 1
                    self.label.transform = .identity
                } completion: { isFinished in
                    if isFinished {
                        self.label.text = ""
                        self.delegate?.presentMainFlow()
                    }
                }
        }
       
    }
}
