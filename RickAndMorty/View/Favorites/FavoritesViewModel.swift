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
    private lazy var cancellables = Set<AnyCancellable>()
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
    
    func toggleFavorite(episode: Result, character: Character) -> Bool {
        let favorite = FavoriteEpisodes(episode: episode, character: character)
        let isCurrentlyFavorite = favoritesManager.isFavorite(episode.id)
        
        if isCurrentlyFavorite {
            favoritesManager.removeFavorite(by: episode.id)
        } else {
            favoritesManager.addFavorite(favorite)
        }
        
        return !isCurrentlyFavorite
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
