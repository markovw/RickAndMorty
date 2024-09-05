//
//  FavoritesViewModel.swift
//  RickAndMorty
//
//  Created by Vladislav on 30.08.2024.
//

import Foundation
import Combine

class FavoritesViewModel {
    @Published var favoriteEpisodes: [FavoriteEpisodes] = []
    @Published var selectedFavorite: (episode: Result, character: Character)?
    private var cancellables = Set<AnyCancellable>()
    private let favoritesManager: FavoritesManager
    
    init(favoritesManager: FavoritesManager) {
        self.favoritesManager = favoritesManager
        self.favoriteEpisodes = favoritesManager.favoriteEpisodes
        
        favoritesManager.$favoriteEpisodes
            .sink { [weak self] episodes in
                self?.favoriteEpisodes = episodes
            }
            .store(in: &cancellables)
    }
    
    func removeFavorite(at index: Int) {
        let favorite = favoriteEpisodes[index]
        favoritesManager.removeFavorite(by: favorite.episode.id)
    }
    
    func isFavorite(_ id: Int) -> Bool {
        return favoritesManager.isFavorite(id)
    }
    
    func didSelectFavorite(at index: Int) {
        let favorite = favoriteEpisodes[index]
        selectedFavorite = (episode: favorite.episode, character: favorite.character)
    }
}
