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
    var viewModel: EpisodesViewModel
    var favoritesManager: FavoritesManager

    init(viewModel: EpisodesViewModel, favoritesManager: FavoritesManager) {
        self.viewModel = viewModel
        self.favoritesManager = favoritesManager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        viewModel.$selectedEpisode
            .compactMap { $0 }
            .sink { episode, character in
                print("tapped episode in general")
            }
            .store(in: &cancellables)
    }
}

extension EpisodesViewController: UICollectionViewDataSource, EpisodesCellViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return section == 0 ? 1 : viewModel.episodes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return indexPath.section == 0
        ? dequeueHeaderCell(for: indexPath)
        : dequeueEpisodeCell(for: indexPath)
    }
    
    private func dequeueHeaderCell(for indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "headerCell",
            for: indexPath
        ) as? EpisodesHeaderView else {
            fatalError("Unable to dequeue HeaderCellView")
        }
        configureHeaderCell(cell)
        return cell
    }
    
    private func dequeueEpisodeCell(for indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "episode",
            for: indexPath
        ) as? EpisodesCellView else {
            fatalError("Unable to dequeue EpisodeCellView")
        }
        configureEpisodeCell(cell, at: indexPath)
        return cell
    }
    
    private func configureHeaderCell(_ cell: EpisodesHeaderView) {
        cell.logoImageView.image = UIImage(named: "logoImage")
        cell.searchTextField.placeholder = "Name or episode (ex. S01E01)"
        cell.filterButton.setTitle("ADVANCED FILTERS", for: .normal)
    }
    
    private func configureEpisodeCell(_ cell: EpisodesCellView, at indexPath: IndexPath) {
        let episode = viewModel.episodes[indexPath.row]
        guard indexPath.row < viewModel.episodeImages.count else {
            configurePlaceholderCell(cell, with: episode)
            return
        }
        let character = viewModel.episodeImages[indexPath.row]
        let isFavorite = favoritesManager.isFavorite(episode.id)
        
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
    }
    
    private func configurePlaceholderCell(_ cell: EpisodesCellView, with episode: Result) {
        let placeholderCharacter = Character(
            image: "placeholder",
            name: "Loading..",
            status: "Loading..",
            species: "Loading..",
            gender: "Loading..",
            location: Location(name: "Unknown"),
            origin: Origin(name: "Unknown"),
            type: "Loading.."
        )
        cell.characterName.text = placeholderCharacter.name
        cell.episodeImage.image = UIImage(named: "placeholder")
        cell.configure(with: episode, with: placeholderCharacter, isFavorite: favoritesManager.isFavorite(episode.id))
        cell.delegate = self
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 1 {

            viewModel.didSelectEpisode(at: indexPath)
        }
    }
    
    func didTapFavoriteButton(in cell: EpisodesCellView) {
        if let indexPath = collectionView.indexPath(for: cell) {
            let selectedEpisode = viewModel.episodes[indexPath.row]
            let selectedCharacter = viewModel.episodeImages[indexPath.row]
            let favorite = FavoriteEpisodes(episode: selectedEpisode, character: selectedCharacter)
            let isCurrentlyFavorite = favoritesManager.isFavorite(selectedEpisode.id) // Используем экземпляр favoritesManager
            
            if isCurrentlyFavorite {
                favoritesManager.removeFavorite(by: favorite.episode.id) // Используем экземпляр favoritesManager
            } else {
                favoritesManager.addFavorite(favorite) // Используем экземпляр favoritesManager
                showAlert(for: selectedCharacter)
            }
            cell.updateFavoriteButton(isFavorite: !isCurrentlyFavorite)
            collectionView.reloadData()
        }
    }
    
    private func showAlert(for character: Character) {
        let alert = UIAlertController(title: "Success", message: "Added \(character.name) to Favorites!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    private func deleteItem(at indexPath: IndexPath) {
        viewModel.episodes.remove(at: indexPath.row)
        viewModel.episodeImages.remove(at: indexPath.row)
        collectionView.deleteItems(at: [indexPath])
    }
}
