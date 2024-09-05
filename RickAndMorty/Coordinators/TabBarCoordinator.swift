//
//  TabBarCoordinator.swift
//  RickAndMorty
//
//  Created by Vladislav on 29.08.2024.
//

import UIKit
import Combine

class TabBarCoordinator: Coordinator {
    
    private let tabBarController: UITabBarController
    internal var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    var appCoordinator: AppCoordinator?
    private let dependencies: IDependency
    private var cancellables = Set<AnyCancellable>()
    
    init(_ navigationController: UINavigationController,
         appCoordinator: AppCoordinator,
         dependencies: IDependency) {
        self.navigationController = navigationController
        self.tabBarController = UITabBarController()
        self.appCoordinator = appCoordinator
        self.dependencies = dependencies
    }
    
    func start() {
        let episodesViewController = dependencies.moduleContainer.getEpisodesView()
        let espisodesNavController = UINavigationController(rootViewController: episodesViewController)
        episodesViewController.tabBarItem = UITabBarItem(title: "",
                                                         image: UIImage(systemName: "house"),
                                                         selectedImage: UIImage(systemName: "house.fill"))
        
        let favoritesViewController = dependencies.moduleContainer.getFavoritesView()
        let favoritesNavController = UINavigationController(rootViewController: favoritesViewController)
        favoritesViewController.tabBarItem = UITabBarItem(title: "",
                                                          image: UIImage(systemName: "heart"),
                                                          selectedImage: UIImage(systemName: "heart.fill"))
        
        tabBarController.viewControllers = [espisodesNavController, favoritesNavController]
        tabBarController.tabBar.isTranslucent = false
        
        navigationController.setViewControllers([tabBarController], animated: true)
        navigationController.setNavigationBarHidden(true, animated: false)
        
        if let episodesVC = episodesViewController as? EpisodesViewController {
            episodesVC.viewModel.$selectedEpisode
                .compactMap { $0 }
                .sink { [weak self] episode, character in
                    self?.showDetail(for: episode, character: character)
                }
                .store(in: &cancellables)
        }
        
        if let favoritesVC = favoritesViewController as? FavoritesViewController {
            favoritesVC.viewModel.$selectedFavorite
                .compactMap { $0 }
                .sink { [weak self] episode, character in
                    self?.showDetail(for: episode, character: character)
                }
                .store(in: &cancellables)
        }
    }
    
    func showDetail(for episode: Result, character: Character) {
        let detailViewController = DetailViewController()
        detailViewController.episode = episode
        detailViewController.character = character
        navigationController.pushViewController(detailViewController, animated: true)
    }
}
