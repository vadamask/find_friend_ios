//
//  SplashView.swift
//  FindFriends
//
//  Created by Artem Novikov on 26.02.2024.
//

import UIKit

final class SplashView: UIView {

    private enum Constants {
        static let width: CGFloat = 164
        static let height: CGFloat = 183
        static let centerYInset: CGFloat = -72
    }

    private var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .logoWithText
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        backgroundColor = .backgroundLaunchScreen
        addSubviewWithoutAutoresizingMask(logoImageView)
    }

    private func setupLayout() {
        NSLayoutConstraint.activate([
            logoImageView.widthAnchor.constraint(equalToConstant: Constants.width),
            logoImageView.heightAnchor.constraint(equalToConstant: Constants.height),
            logoImageView.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            logoImageView.centerYAnchor.constraint(
                equalTo: safeAreaLayoutGuide.centerYAnchor,
                constant: Constants.centerYInset
            )
        ])
    }
}
