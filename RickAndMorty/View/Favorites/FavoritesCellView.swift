//
//  FavoritesCellView.swift
//  RickAndMorty
//
//  Created by Vladislav on 30.08.2024.
//

import UIKit

extension FavoritesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return FavoritesManager.shared.favoriteEpisodes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "episode", for: indexPath) as? EpisodesCellView else {
            fatalError("Unable to dequeue EpisodesCellView")
        }
        
        let favorite = FavoritesManager.shared.favoriteEpisodes[indexPath.item]
        let episode = favorite.episode
        let character = favorite.character
        let isFavorite = FavoritesManager.shared.isFavorite(episode.id)
        cell.configure(with: episode, with: character, isFavorite: isFavorite)
        
        if let characterURL = URL(string: character.image) {
            cell.episodeImage.kf.setImage(
                with: characterURL,
                placeholder: UIImage(named: "placeholder"),
                options: [
                    .transition(.fade(0.2)),
                    .cacheOriginalImage
                ]
            )
        } else {
            cell.episodeImage.image = UIImage(named: "placeholder")
        }
        cell.delegate = self
        return cell
    }
}

extension FavoritesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let favorite = FavoritesManager.shared.favoriteEpisodes[indexPath.item]
        coordinator?.showDetail(for: favorite.episode, character: favorite.character)
    }
}
