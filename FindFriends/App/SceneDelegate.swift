//
//  SceneDelegate.swift
//  FindFriends
//
//  Created by Vitaly on 08.02.2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var appCoordinator: Coordinator?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)
        
        appCoordinator = AppCoordinator(navigationController: setupNavController())
        appCoordinator?.start()
        
        window?.rootViewController = appCoordinator?.navigationController
        window?.makeKeyAndVisible()
    }
    
    private func setupNavController() -> UINavigationController {
        let controller = UINavigationController()
        controller.navigationBar.prefersLargeTitles = true
        controller.navigationBar.tintColor = .primeDark
        controller.navigationBar.largeTitleTextAttributes = [
            .foregroundColor: UIColor.primeDark
        ]
        return controller
    }
}

