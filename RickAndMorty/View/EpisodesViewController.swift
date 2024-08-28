//
//  ViewController.swift
//  RickAndMorty
//
//  Created by Vladislav on 23.08.2024.
//


import UIKit
import Combine
import Kingfisher

class EpisodesViewController: UIViewController {
    
    private var collectionView: UICollectionView!
    private var cancellables = Set<AnyCancellable>()
    
    var viewModel: EpisodesViewModel
    
    init(viewModel: EpisodesViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        collectionView.register(EpisodeCellView.self, forCellWithReuseIdentifier: "episode")
        collectionView.register(HeaderCellView.self, forCellWithReuseIdentifier: "headerCell")
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

