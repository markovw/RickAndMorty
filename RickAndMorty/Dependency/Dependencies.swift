//
//  Dependencies.swift
//  RickAndMorty
//
//  Created by Vladislav on 23.08.2024.
//

import Foundation

protocol IDependency {
    var networkManager: NetworkManager { get }
    var characterFetcher: CharacterFetcher { get }
}

final class Dependencies: IDependency {
    static let shared = Dependencies()
    
    lazy var networkManager: NetworkManager = NetworkManager()
    lazy var characterFetcher: CharacterFetcher = CharacterFetcher()
    lazy var episodesViewController: EpisodesViewController = EpisodesViewController(
        viewModel: EpisodesViewModel(
            networkManager: networkManager,
            characterFetcher: characterFetcher
        )
    )
    lazy var favoritesViewController: FavoritesViewController = FavoritesViewController(
        viewModel: FavoritesViewModel(
            favoritesManager: FavoritesManager.shared
        )
    )
}
