import UIKit

protocol AppCoordinatorProtocol: Coordinator {
    func presentAuthFlow()
    func presentMainFlow()
    func presentFillProfileFlow()
}

final class AppCoordinator: AppCoordinatorProtocol {
    var navigationController: UINavigationController
        
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let service = UsersService()
        let splashViewModel = SplashViewModel(service: service, coordinator: self)
        let splashView = SplashView(viewModel: splashViewModel)
        let splashVC = SplashViewController(splashView: splashView)
        navigationController.pushViewController(splashVC, animated: false)
    }
    
    func presentAuthFlow() {
        let coordinator = AuthCoordinator(navigationController: navigationController)
        coordinator.start()
    }
    
    func presentMainFlow() {
        let tabBar = TabBar()
        let tabBarController = TabBarController(customTabBar: tabBar)
        self.navigationController.pushViewController(tabBarController, animated: true)
    }
    
    func presentFillProfileFlow() {
        let fillProfileVC = FillProfilePageViewController()
        self.navigationController.pushViewController(fillProfileVC, animated: true)
    }
}
