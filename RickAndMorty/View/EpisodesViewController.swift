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
    private var topContainerView: UIView!
    private var textField: UITextField!
    private var searchButton: UIButton!
    private var filterButton: UIButton!
    private var cancellables = Set<AnyCancellable>()
    var viewModel: EpisodesViewModel = EpisodesViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTopContainerView()
        setupCollectionView()
        bindViewModel()
        viewModel.loadEpisodes()
        
    }
    
    private func setupTopContainerView() {
        topContainerView = UIView()
        topContainerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(topContainerView)
        
        let textField: UITextField = {
            let textField = UITextField()
            textField.placeholder = "Name or episode (ex.S01E01)..."
            textField.borderStyle = .roundedRect
            textField.translatesAutoresizingMaskIntoConstraints = false
            topContainerView.addSubview(textField)
            return textField
        }()
        
        let filterButton: UIButton = {
            let filterButton = UIButton(type: .system)
            filterButton.setTitle("ADVANCED FILTERS", for: .normal)
            filterButton.tintColor = .textButton
            filterButton.backgroundColor = .filterButton
            filterButton.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
            filterButton.layer.cornerRadius = 4
            filterButton.translatesAutoresizingMaskIntoConstraints = false
            topContainerView.addSubview(filterButton)
            return filterButton
        }()
        
        // container constraints
        NSLayoutConstraint.activate([
            topContainerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            topContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            topContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
        ])
        
        // container elements constraints
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: topContainerView.topAnchor),
            textField.leadingAnchor.constraint(equalTo: topContainerView.leadingAnchor),
            textField.trailingAnchor.constraint(equalTo: topContainerView.trailingAnchor),
            textField.heightAnchor.constraint(equalToConstant: 40),
            
            filterButton.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 8),
            filterButton.leadingAnchor.constraint(equalTo: topContainerView.leadingAnchor),
            filterButton.trailingAnchor.constraint(equalTo: topContainerView.trailingAnchor),
            filterButton.heightAnchor.constraint(equalToConstant: 56),
            
            filterButton.bottomAnchor.constraint(equalTo: topContainerView.bottomAnchor)
        ])
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
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topContainerView.bottomAnchor, constant: 16),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
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


