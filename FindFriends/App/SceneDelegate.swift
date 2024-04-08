//
//  SceneDelegate.swift
//  FindFriends
//
//  Created by Vitaly on 08.02.2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)
        
        let splashViewModel = SplashViewModel()
        let splashView = SplashView(viewModel: splashViewModel)
        let splashVC = SplashViewController(splashView: splashView)
        splashView.delegate = splashVC
        
        window?.rootViewController = splashVC
        window?.makeKeyAndVisible()
    }
}

