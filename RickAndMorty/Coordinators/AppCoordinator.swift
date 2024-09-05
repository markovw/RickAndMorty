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
    private let dependencies: IDependency
    
    required init(window: UIWindow,
                  _ navigationController: UINavigationController,
                  dependencies: IDependency) {
        self.window = window
        self.navigationController = navigationController
        self.dependencies = dependencies
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
        let tabBarCoordinator = TabBarCoordinator(navigationController, appCoordinator: self, dependencies: dependencies)
        self.tabBarCoordinator = tabBarCoordinator
        childCoordinators.append(tabBarCoordinator)
        tabBarCoordinator.start() 
    }
    
    func showDetail(for episode: Result, character: Character) {
        let detailViewController = DetailViewController()
        detailViewController.episode = episode
        detailViewController.character = character
        navigationController.pushViewController(detailViewController, animated: true)
        navigationController.interactivePopGestureRecognizer?.isEnabled = true
    }
}
