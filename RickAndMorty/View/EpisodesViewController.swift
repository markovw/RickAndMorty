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
    
    var collectionView: UICollectionView!
    var viewModel: EpisodesViewModel = EpisodesViewModel()
    var cancellables = Set<AnyCancellable>()
    
    required init?(coder: NSCoder) {
        self.viewModel = EpisodesViewModel()
        super.init(coder: coder)
    }
    
    var logoImage: UIImageView = {
        let logoImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 312, height: 104))
        logoImage.contentMode = .scaleAspectFill
        logoImage.clipsToBounds = true
//        logoImage.translatesAutoresizingMaskIntoConstraints = false

        logoImage.image = UIImage(named: "logoImage")
        return logoImage

    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        bindViewModel()
        viewModel.loadEpisodes()
        

    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 311, height: 357)
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 55
        layout.minimumLineSpacing = 55
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.register(EpisodeCellView.self, forCellWithReuseIdentifier: "episode")
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.contentInset = UIEdgeInsets(top: 380, left: 0, bottom: 0, right: 0)
        

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


