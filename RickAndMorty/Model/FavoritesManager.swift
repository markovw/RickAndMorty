import Foundation
import Combine

class FavoritesManager {
    static let shared = FavoritesManager()
    
    var favoriteEpisodes: [FavoriteEpisodes] = []
    
    private init() {}
    
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
