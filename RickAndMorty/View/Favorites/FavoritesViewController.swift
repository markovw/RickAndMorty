//
//  FavoritesView.swift
//  RickAndMorty
//
//  Created by Vladislav on 29.08.2024.
//

import UIKit
import Kingfisher

class FavoritesViewController: UIViewController {
    private var collectionView: UICollectionView!
    
    var favorites: [FavoriteEpisodes] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 311, height: 357)
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 55
        layout.minimumLineSpacing = 55
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = .background
        collectionView.register(EpisodesCellView.self, forCellWithReuseIdentifier: "episode")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension FavoritesViewController: UICollectionViewDelegate {}


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
        
        return cell
    }
}
