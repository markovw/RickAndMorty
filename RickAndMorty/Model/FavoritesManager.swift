import Foundation
import Combine

class FavoritesManager {
    static let shared = FavoritesManager()
    
    private(set) var favoriteEpisodes: [FavoriteEpisodes] = []
    
    private init() {}
    
    func addFavorite(_ favorite: FavoriteEpisodes) {
        favoriteEpisodes.append(favorite)
    }
    
    func removeFavorite(by id: Int) {
        favoriteEpisodes.removeAll { $0.episode.id == id }
    }
    
    func isFavorite(_ id: Int) -> Bool {
        return favoriteEpisodes.contains { $0.episode.id == id }
    }
}
