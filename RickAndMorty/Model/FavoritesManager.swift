import Foundation
import Combine

class FavoritesManager {
    private let favoritesKey = "favoriteEpisodes"
    
    @Published var favoriteEpisodes: [FavoriteEpisodes] = []
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        loadFavorites()
        
        $favoriteEpisodes
            .sink { [weak self] episodes in
                self?.saveFavorites(episodes)
            }
            .store(in: &cancellables)
    }
    
    private func saveFavorites(_ episodes: [FavoriteEpisodes]) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(episodes) {
            UserDefaults.standard.set(encoded, forKey: favoritesKey)
        }
    }
    
    private func loadFavorites() {
        if let savedData = UserDefaults.standard.data(forKey: favoritesKey) {
            let decoder = JSONDecoder()
            if let loadedEpisodes = try? decoder.decode([FavoriteEpisodes].self, from: savedData) {
                favoriteEpisodes = loadedEpisodes
            }
        }
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
