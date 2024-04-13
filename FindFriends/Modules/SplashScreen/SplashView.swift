//
//  SplashView.swift
//  FindFriends
//
//  Created by Artem Novikov on 26.02.2024.
//

import Combine
import SnapKit
import UIKit

final class SplashView: UIView {

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
        addSubview(logoImageView)
        addSubview(label)
        
        logoImageView.snp.makeConstraints { make in
            make.width.equalTo(137)
            make.height.equalTo(139)
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-72)
        }
        
        label.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(logoImageView.snp.bottom).offset(20)
        }
    }
    
    private func bind() {
        viewModel.state
            .sink { [unowned self] state in
                switch state {
                case .login:
                    animateWelcomeViewEntrance()
                case .unlogin:
                    viewModel.presentAuthFlow()
                case .unfinishedRegistration:
                    viewModel.presentFillProfileFlow()
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
                        self.viewModel.presentMainFlow()
                    }
                }
        }
    }
}
