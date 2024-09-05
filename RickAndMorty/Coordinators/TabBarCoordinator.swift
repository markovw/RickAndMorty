//
//  TabBarCoordinator.swift
//  RickAndMorty
//
//  Created by Vladislav on 29.08.2024.
//

import UIKit

class TabBarCoordinator: Coordinator {
    
    private let tabBarController: UITabBarController
    internal var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    var appCoordinator: AppCoordinator?
    
    init(_ navigationController: UINavigationController, appCoordinator: AppCoordinator) {
        self.navigationController = navigationController
        self.tabBarController = UITabBarController()
        self.appCoordinator = appCoordinator
    }
    
    func start() {
        let episodesViewController = Dependencies.shared.episodesViewController
        episodesViewController.coordinator = appCoordinator
        let espisodesNavController = UINavigationController(rootViewController: episodesViewController)
        episodesViewController.tabBarItem = UITabBarItem(title: "",
                                                         image: UIImage(systemName: "house"),
                                                         selectedImage: UIImage(systemName: "house.fill"))
        
        let favoritesViewController = Dependencies.shared.favoritesViewController
        favoritesViewController.coordinator = appCoordinator
        let favoritesNavController = UINavigationController(rootViewController: favoritesViewController)
        favoritesViewController.tabBarItem = UITabBarItem(title: "",
                                                          image: UIImage(systemName: "heart"),
                                                          selectedImage: UIImage(systemName: "heart.fill"))
        
        tabBarController.viewControllers = [espisodesNavController, favoritesNavController]
        tabBarController.tabBar.isTranslucent = false
        
        navigationController.setViewControllers([tabBarController], animated: true)
        navigationController.setNavigationBarHidden(true, animated: false)
    }
}
