//
//  Dependencies.swift
//  RickAndMorty
//
//  Created by Vladislav on 23.08.2024.
//

import Foundation

protocol IDependency {
    var moduleContainer: IModuleContainer { get }
    var networkManager: NetworkManager { get }
    var characterFetchService: CharacterFetchService { get }
    var favoritesManager: FavoritesManager { get }
    var favoritesViewModel: FavoritesViewModel { get }
}

final class Dependencies: IDependency {
    lazy var favoritesViewModel: FavoritesViewModel = FavoritesViewModel(favoritesManager: favoritesManager)
    lazy var favoritesManager: FavoritesManager = FavoritesManager()
    lazy var moduleContainer: IModuleContainer = ModuleContainer(self)
    lazy var networkManager: NetworkManager = NetworkManager()
    lazy var characterFetchService: CharacterFetchService = CharacterFetchService()
}
