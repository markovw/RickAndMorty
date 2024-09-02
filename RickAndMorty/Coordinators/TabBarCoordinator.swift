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
    
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.tabBarController = UITabBarController()
    }
    
    func start() {
        let episodesViewController = EpisodesViewController()
        let espisodesNavController = UINavigationController(rootViewController: episodesViewController)
        episodesViewController.tabBarItem = UITabBarItem(title: "",
                                                         image: UIImage(systemName: "house"),
                                                         selectedImage: UIImage(systemName: "house.fill"))
        
        let favoritesViewController = FavoritesViewController()
        let favoritesNavController = UINavigationController(rootViewController: favoritesViewController)
        favoritesViewController.tabBarItem = UITabBarItem(title: "",
                                                          image: UIImage(systemName: "heart"),
                                                          selectedImage: UIImage(systemName: "heart.fill"))
        
        tabBarController.viewControllers = [espisodesNavController, favoritesNavController]
        navigationController.setViewControllers([tabBarController], animated: true)
        navigationController.setNavigationBarHidden(true, animated: false)
    }
}

