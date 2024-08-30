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
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupEpisodesView()
        bindViewModel()
        viewModel.loadEpisodes()
        
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

extension EpisodesViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return section == 0 ? 1 : viewModel.episodes.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            // MARK: TopBarSection
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "headerCell",
                for: indexPath
            ) as? EpisodesHeaderView else {
                fatalError("Unable to dequeue HeaderCellView")
            }
            // customizing elements
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
            
            let episode = viewModel.episodes[indexPath.row]
            // text
            cell.episodeTitle.text = "\(episode.name) | \(episode.episode)"
            cell.episodeIcon.image = UIImage(named: "playIcon")
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
    // MARK: Adding to Favorites
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            let selectedEpisode = viewModel.episodes[indexPath.row]
            let selectedImage = viewModel.episodeImages[indexPath.row]
            
            let favorite = FavoriteEpisodes(episode: selectedEpisode,
                                            character: selectedImage)
            print(favorite)

            // add to favorites list
            FavoritesManager.shared.addFavorite(favorite)
        }
    }
}
