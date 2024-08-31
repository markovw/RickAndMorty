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
    private lazy var favorites: [FavoriteEpisodes] = []
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Favorites episodes"
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: – Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(titleLabel) 
        setupCollectionView()
        setupConstraints()
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
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            collectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}


extension FavoritesViewController: EpisodesCellViewDelegate {
    func didTapFavoriteButton(in cell: EpisodesCellView) {
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
        let favorite = FavoritesManager.shared.favoriteEpisodes[indexPath.item]
        
        // Удаляем элемент из избранного
        FavoritesManager.shared.removeFavorite(by: favorite.episode.id)
        
        // Обновляем collectionView
        collectionView.performBatchUpdates({
            collectionView.deleteItems(at: [indexPath])
        }, completion: { _ in
            // Optionally, show a confirmation or refresh UI
        })
    }
}



