//
//  ViewController.swift
//  RickAndMorty
//
//  Created by Vladislav on 23.08.2024.
//

import UIKit
import Combine
import Kingfisher

class EpisodesViewController: UIViewController, UICollectionViewDelegate {
    private var collectionView: UICollectionView!
    private var cancellables = Set<AnyCancellable>()
    var viewModel = EpisodesViewModel()
    
    // MARK: – Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupEpisodesView()
        bindViewModel()
        viewModel.loadEpisodes()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
    }
}

private extension EpisodesViewController {
    private func setupEpisodesView() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 311, height: 357)
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 55
        layout.minimumLineSpacing = 55
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = .background
        collectionView.register(EpisodesCellView.self, forCellWithReuseIdentifier: "episode")
        collectionView.register(EpisodesHeaderView.self, forCellWithReuseIdentifier: "headerCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
    }
    
    private func bindViewModel() {
        viewModel.$episodes
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.collectionView.reloadData()
            }
            .store(in: &cancellables)
    }
}

extension EpisodesViewController: UICollectionViewDataSource, EpisodesCellViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return section == 0 ? 1 : viewModel.episodes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            // MARK: TopBarSection
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "headerCell",
                for: indexPath
            ) as? EpisodesHeaderView else {
                fatalError("Unable to dequeue HeaderCellView")
            }
            // Customizing elements
            cell.logoImageView.image = UIImage(named: "logoImage")
            cell.searchTextField.placeholder = "Name or episode (ex. S01E01)"
            cell.filterButton.setTitle("ADVANCED FILTERS", for: .normal)
            return cell
        } else {
            // MARK: EpisodesSection
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "episode",
                for: indexPath
            ) as? EpisodesCellView else {
                fatalError("Unable to dequeue EpisodeCellView")
            }
            
            guard indexPath.row < viewModel.episodes.count else {
                fatalError("Index out of range for episodes array")
            }
            let episode = viewModel.episodes[indexPath.row]
            
            guard indexPath.row < viewModel.episodeImages.count else {
                let placeholderCharacter = Character(image: "placeholder", name: "Loading..", species: "")
                cell.characterName.text = placeholderCharacter.name
                cell.episodeImage.image = UIImage(named: "placeholder")
                cell.configure(with: episode, with: placeholderCharacter, isFavorite: FavoritesManager.shared.isFavorite(episode.id))
                cell.delegate = self
                return cell
            }
            
            let character = viewModel.episodeImages[indexPath.row]
            let isFavorite = FavoritesManager.shared.isFavorite(episode.id)
            
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
            
            cell.configure(with: episode, with: character, isFavorite: isFavorite)
            cell.delegate = self
            
            return cell
        }
    }
    // MARK: Adding to Favorites
    func didTapFavoriteButton(in cell: EpisodesCellView) {
        if let indexPath = collectionView.indexPath(for: cell) {
            let selectedEpisode = viewModel.episodes[indexPath.row]
            let selectedImage = viewModel.episodeImages[indexPath.row]
            let favorite = FavoriteEpisodes(episode: selectedEpisode, character: selectedImage)
            let isCurrentlyFavorite = FavoritesManager.shared.isFavorite(selectedEpisode.id)
            
            if isCurrentlyFavorite {
                FavoritesManager.shared.removeFavorite(by: favorite.episode.id)
            } else {
                // Если эпизод не в избранном, добавляем его
                FavoritesManager.shared.addFavorite(favorite)
                
                let alert = UIAlertController(title: "Success", message: "Added \(selectedImage.name) to Favorites!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            cell.updateFavoriteButton(isFavorite: !isCurrentlyFavorite)
            collectionView.reloadData()
        }
    }
}
