//
//  FavoritesViewModel.swift
//  RickAndMorty
//
//  Created by Vladislav on 30.08.2024.
//

import Foundation
import Combine

class FavoritesViewModel {
    private let favoritesManager: FavoritesManager
    private var cancellables = Set<AnyCancellable>()
    
    @Published var favoriteEpisodes: [FavoriteEpisodes] = []
    
    init(favoritesManager: FavoritesManager) {
        self.favoritesManager = favoritesManager
        self.favoriteEpisodes = favoritesManager.favoriteEpisodes
    }
    
    func removeFavorite(at index: Int) {
        let favorite = favoriteEpisodes[index]
        favoritesManager.removeFavorite(by: favorite.episode.id)
        favoriteEpisodes.remove(at: index)
    }
}
