import Foundation
import UIKit

class FavoritesManager {
    static let shared = FavoritesManager()
    
    private let favoritesKey = "favoriteEpisodes"
    
    var favoriteEpisodes: [FavoriteEpisodes] {
        get {
            loadFavorites()
        }
        set {
            saveFavorites(newValue)
        }
    }
    
    private init() {}
    
    private func saveFavorites(_ episodes: [FavoriteEpisodes]) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(episodes) {
            UserDefaults.standard.set(encoded, forKey: favoritesKey)
        }
    }
    
    private func loadFavorites() -> [FavoriteEpisodes] {
        if let savedData = UserDefaults.standard.data(forKey: favoritesKey) {
            let decoder = JSONDecoder()
            if let loadedEpisodes = try? decoder.decode([FavoriteEpisodes].self, from: savedData) {
                return loadedEpisodes
            }
        }
        return []
    }
    
    func addFavorite(_ favorite: FavoriteEpisodes) {
        if !isFavorite(favorite.episode.id) {
            favoriteEpisodes.insert(favorite, at: 0)
        }
    }
    
    func removeFavorite(by id: Int) {
        favoriteEpisodes.removeAll { $0.episode.id == id }
    }
    
    func isFavorite(_ id: Int) -> Bool {
        return favoriteEpisodes.contains { $0.episode.id == id }
    }
}
