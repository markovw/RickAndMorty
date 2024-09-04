//
//  ViewController.swift
//  RickAndMorty
//
//  Created by Vladislav on 23.08.2024.
//

import UIKit
import Combine
import Kingfisher

class EpisodesViewController: UIViewController, UICollectionViewDelegate, EpisodesHeaderViewDelegate {
    private var collectionView: UICollectionView!
    private var cancellables = Set<AnyCancellable>()
    private var viewModel = EpisodesViewModel()
    var coordinator: AppCoordinator?
    
    // MARK: – Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupEpisodesView()
        setupHeaderView()
        bindViewModel()
        viewModel.loadEpisodes()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
    }
    
    func didUpdateSearchText(_ text: String) {
        viewModel.searchText = text
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
    
    private func setupHeaderView() {
        let headerView = EpisodesHeaderView()
        headerView.delegate = self
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
                let placeholderLocation = Location(name: "Unknown")
                let placeholderOrigin = Origin(name: "Unknown")
                
                let placeholderCharacter = Character(
                    image: "placeholder",
                    name: "Loading..",
                    status: "Loading..",
                    species: "Loading..",
                    gender: "Loading..",
                    location: placeholderLocation,
                    origin: placeholderOrigin,
                    type: "Loading.."
                )
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
    // MARK: Transition to DetailVC
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            let episode = viewModel.episodes[indexPath.row]
            guard indexPath.row < viewModel.episodeImages.count else { return }
            let character = viewModel.episodeImages[indexPath.row]
            
            coordinator?.showDetail(for: episode, character: character)
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
                FavoritesManager.shared.addFavorite(favorite)
                
                let alert = UIAlertController(title: "Success", message: "Added \(selectedImage.name) to Favorites!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            cell.updateFavoriteButton(isFavorite: !isCurrentlyFavorite)
            collectionView.reloadData()
        }
    }
    // MARK: Deleting the cell by swipe
    func collectionView(_ collectionView: UICollectionView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (action, view, completionHandler) in
            self?.deleteItem(at: indexPath)
            completionHandler(true)
        }
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        configuration.performsFirstActionWithFullSwipe = true
        return configuration
    }
    
    private func deleteItem(at indexPath: IndexPath) {
        viewModel.episodes.remove(at: indexPath.row)
        viewModel.episodeImages.remove(at: indexPath.row)
        
        collectionView.deleteItems(at: [indexPath])
    }
}

