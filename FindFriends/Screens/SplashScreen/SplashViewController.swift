//
//  SplashViewController.swift
//  FindFriends
//
//  Created by Artem Novikov on 26.02.2024.
//

import UIKit

final class SplashViewController: UIViewController {
    
    private let splashView: SplashView
    
    init(splashView: SplashView) {
        self.splashView = splashView
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = splashView
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        splashView.viewDidAppear()
    }
    
    private func presentLoginViewController() {
        let viewController = LoginViewController()
        let navigationController = RegistrationNavigationController(rootViewController: viewController)
        navigationController.modalTransitionStyle = .crossDissolve
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true)
    }
    
    private func presentTabBarController() {
        let tabBar = TabBar()
        let tabBarController = TabBarController(customTabBar: tabBar)
        tabBarController.modalTransitionStyle = .crossDissolve
        tabBarController.modalPresentationStyle = .fullScreen
        present(tabBarController, animated: true)
    }
    
    private func presentFillProfile() {
        let fillProfileVC = FillProfilePageViewController()
        fillProfileVC.modalTransitionStyle = .crossDissolve
        fillProfileVC.modalPresentationStyle = .fullScreen
        present(fillProfileVC, animated: true)
    }
}

extension SplashViewController: SplashViewDelegate {
    func presentMainFlow() {
        presentTabBarController()
    }
    
    func presentLoginFlow() {
        presentLoginViewController()
    }
    
    func presentFillingFlow() {
        presentFillProfile()
    }
}
