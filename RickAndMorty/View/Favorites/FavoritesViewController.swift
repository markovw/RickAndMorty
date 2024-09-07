//
//  FavoritesView.swift
//  RickAndMorty
//
//  Created by Vladislav on 29.08.2024.
//

import UIKit
import Kingfisher
import Combine

class FavoritesViewController: UIViewController {
    private var collectionView: UICollectionView!
    private lazy var cancellables = Set<AnyCancellable>()
    var viewModel: FavoritesViewModel
    
    init(viewModel: FavoritesViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Favorites episodes"
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(titleLabel)
        setupCollectionView()
        setupConstraints()
        collectionView.delegate = self
        
        viewModel.$favoriteEpisodes
            .sink { [weak self] _ in
                self?.collectionView.reloadData()
            }
            .store(in: &cancellables)
        viewModel.$selectedFavorite
            .compactMap { $0 }
            .sink { episode, character in
                print("tapped esisode in favorites")
            }
            .store(in: &cancellables)
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
    func didUpdateSearchText(_ text: String) {
        
    }
    
    func didTapFavoriteButton(in cell: EpisodesCellView) {
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
        viewModel.removeFavorite(at: indexPath.item)
    }
}
