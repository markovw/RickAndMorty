//
//  ModuleContainer.swift
//  RickAndMorty
//
//  Created by Vladislav on 23.08.2024.
//

import UIKit

protocol IModuleContainer {
    func getFavoritesView() -> UIViewController
    func getEpisodesView() -> UIViewController
}

final class ModuleContainer: IModuleContainer {
    private let dependencies: IDependency
    
    required init(_ dependencies: IDependency) {
        self.dependencies = dependencies
    }
}

// MARK: - FavoritesVC
extension ModuleContainer {
    func getFavoritesView() -> UIViewController {
        let favoritesManager = dependencies.favoritesManager
        let viewModel = FavoritesViewModel(favoritesManager: favoritesManager)
        let view = FavoritesViewController(viewModel: viewModel)
        return view
    }
}

// MARK: – EpisodesVC
extension ModuleContainer {
    func getEpisodesView() -> UIViewController {
        let favoritesManager = dependencies.favoritesManager
        let favoritesViewModel = dependencies.favoritesViewModel
        let networkManager = dependencies.networkManager
        let characterFetchService = dependencies.characterFetchService
        let viewModel = EpisodesViewModel(networkManager: networkManager, characterFetchService: characterFetchService)
        let view = EpisodesViewController(viewModel: viewModel, favoritesManager: favoritesManager, favoritesViewModel: favoritesViewModel)
        return view
    }
}
