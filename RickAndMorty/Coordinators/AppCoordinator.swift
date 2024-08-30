//
//  AppCoordinator.swift
//  RickAndMorty
//
//  Created by Vladislav on 26.08.2024.
//

import UIKit

final class AppCoordinator: Coordinator {
    var navigationController: UINavigationController
    var childCoordinators = [Coordinator]()
    
    let window: UIWindow
    private var tabBarCoordinator: TabBarCoordinator?

    required init(window: UIWindow, _ navigationController: UINavigationController) {
        self.window = window
        self.navigationController = navigationController
    }
    
    func start() {
        let onboardingCoordinator = OnboardingCoordinator(navigationController)
        childCoordinators.append(onboardingCoordinator)
        onboardingCoordinator.onFinish = { [weak self] in
            self?.showMainApp()
        }
        onboardingCoordinator.start()
        
        window.rootViewController = navigationController
        window.backgroundColor = .white
        window.makeKeyAndVisible()
    }
    
    private func showMainApp() {
        let tabBarCoordinator = TabBarCoordinator(navigationController)
        self.tabBarCoordinator = tabBarCoordinator
        childCoordinators.append(tabBarCoordinator)
        tabBarCoordinator.start()
    }
}



