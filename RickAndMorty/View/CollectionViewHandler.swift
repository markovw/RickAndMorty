//
//  CollectionViewHandler.swift
//  RickAndMorty
//
//  Created by Vladislav on 24.08.2024.
//

import Foundation
import UIKit
import Kingfisher

extension EpisodesViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return viewModel.episodes.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            
            // MARK: TopBarSection
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "headerCell", for: indexPath) as! HeaderCellView
            
            // Настройка элементов интерфейса внутри этой ячейки
            cell.logoImageView.image = UIImage(named: "logoImage")
            cell.searchTextField.placeholder = "Name or episode (ex. S01E01)"
            cell.filterButton.setTitle("ADVANCED FILTERS", for: .normal)
            
            return cell
            
            
        } else {
            // MARK: EpisodesSection
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "episode", for: indexPath) as! EpisodeCellView
            
            let episode = viewModel.episodes[indexPath.row]
            
            // text
            cell.episodeTitle.text = "\(episode.name) | \(episode.episode)"
            cell.episodeIcon.image = UIImage(named: "playIcon")
            cell.heartIcon.image = UIImage(named: "heartIcon")
            
            // image + text
            if indexPath.row < viewModel.episodeImages.count {
                let character = viewModel.episodeImages[indexPath.row]
                cell.characterName.text = character.name
                
                let url = URL(string: character.image)
                cell.episodeImage.kf.setImage(
                    with: url,
                    placeholder: UIImage(named: "placeholder"),
                    options: [
                        .transition(.fade(0.2)),
                        .cacheOriginalImage
                    ]
                )
            } else {
                cell.characterName.text = "Loading..."
                cell.episodeImage.image = UIImage(named: "placeholder")
            }
            return cell
        }
    }
}

extension EpisodesViewController: UICollectionViewDelegate {
    
}
