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
    private var favoritesManager: FavoritesManager
    var viewModel: EpisodesViewModel
    var favoritesViewModel: FavoritesViewModel
    
    init(viewModel: EpisodesViewModel, favoritesManager: FavoritesManager, favoritesViewModel: FavoritesViewModel) {
        self.viewModel = viewModel
        self.favoritesViewModel = favoritesViewModel
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
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .background
        collectionView.register(EpisodesCellView.self, forCellWithReuseIdentifier: "episode")
        collectionView.register(EpisodesHeaderView.self, forCellWithReuseIdentifier: "headerCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func bindViewModel() {
        viewModel.$episodes
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.collectionView.reloadSections(IndexSet(integer: Section.episodes.rawValue))
            }
            .store(in: &cancellables)
        viewModel.$selectedEpisode
            .compactMap { $0 }
            .sink { _ in
                print("tapped episode in general")
                self.collectionView.reloadData()
            }
            .store(in: &cancellables)
    }
}

extension EpisodesViewController: UICollectionViewDataSource, EpisodesCellViewDelegate {
    private enum Section: Int {
        case header
        case episodes
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let section = Section(rawValue: section) else { return 0 }
        switch section {
        case .header:
            return 1
        case .episodes:
            return viewModel.episodes.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let section = Section(rawValue: indexPath.section) else {
            fatalError("Unknown section")
        }
        
        switch section {
        case .header:
            return dequeueHeaderCell(for: indexPath)
        case .episodes:
            return dequeueEpisodeCell(for: indexPath)
        }
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
        cell.configure(with: viewModel)
    }
    
    private func configureEpisodeCell(_ cell: EpisodesCellView, at indexPath: IndexPath) {
        let episode = viewModel.episodes[indexPath.row]
        guard indexPath.row < viewModel.episodeImages.count else {
            configurePlaceholderCell(cell, with: episode)
            return
        }
        let character = viewModel.episodeImages[indexPath.row]
        let isFavorite = favoritesManager.isFavorite(episode.id)
        
        cell.configure(with: episode, character: character, isFavorite: isFavorite)
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
        cell.configure(with: episode, character: placeholderCharacter,
                       isFavorite: favoritesManager.isFavorite(episode.id))
        cell.delegate = self
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let section = Section(rawValue: indexPath.section) else { return }
        
        switch section {
        case .header:
            break
        case .episodes:
            viewModel.didSelectEpisode(at: indexPath)
        }
    }
    
    func didTapFavoriteButton(in cell: EpisodesCellView) {
        if let indexPath = collectionView.indexPath(for: cell) {
            let selectedEpisode = viewModel.episodes[indexPath.row]
            let selectedCharacter = viewModel.episodeImages[indexPath.row]
            let isFavorite = favoritesViewModel.toggleFavorite(episode: selectedEpisode, character: selectedCharacter)
            cell.updateFavoriteButton(isFavorite: isFavorite)
            collectionView.reloadData()
        }
    }
    
    private func deleteItem(at indexPath: IndexPath) {
        viewModel.episodes.remove(at: indexPath.row)
        viewModel.episodeImages.remove(at: indexPath.row)
        collectionView.deleteItems(at: [indexPath])
    }
}
