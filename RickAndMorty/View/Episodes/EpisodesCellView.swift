//
//  EpisodeView.swift
//  RickAndMorty
//
//  Created by Vladislav on 26.08.2024.
//

import UIKit
import Combine

final class EpisodesCellView: UICollectionViewCell, UICollectionViewDelegate {
    var episode: Result?
    private var cancellables = Set<AnyCancellable>()
    
    let episodeImage: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0,
                                                  width: 311,
                                                  height: 232))
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 4
        imageView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        return imageView
    }()
    let episodeIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    let heartButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "heartIcon"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    let characterName: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let episodeTitle: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 16)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.lineBreakMode = .byTruncatingMiddle
        return label
    }()
    
    // MARK: Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(episodeImage)
        contentView.addSubview(episodeTitle)
        contentView.addSubview(characterName)
        contentView.addSubview(episodeIcon)
        contentView.addSubview(heartButton)
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 4
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOpacity = 0.20
        contentView.layer.shadowOffset = CGSize(width: 0, height: 2)
        contentView.layer.shadowRadius = 4
        // constraints
        NSLayoutConstraint.activate([
            episodeIcon.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 22),
            episodeIcon.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -14),
            episodeIcon.widthAnchor.constraint(equalToConstant: 32),
            episodeIcon.heightAnchor.constraint(equalToConstant: 34),
            episodeTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 65),
            episodeTitle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -88),
            episodeTitle.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            heartButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -18),
            heartButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -14),
            heartButton.widthAnchor.constraint(equalToConstant: 41),
            heartButton.heightAnchor.constraint(equalToConstant: 40),
            characterName.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            characterName.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            characterName.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -83)
        ])
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Configure Favorites View
    func configure(with episode: Result, with image: Character, isFavorite: Bool) {
        episodeIcon.image = UIImage(named: "playIcon")
        episodeTitle.text = "\(episode.name) | \(episode.episode)"
        characterName.text = image.name
        updateFavoriteButton(isFavorite: isFavorite)
        
        if let imageURL = URL(string: episode.characters.first ?? "") {
            episodeImage.kf.setImage(
                with: imageURL,
                placeholder: UIImage(named: "placeholder"),
                options: [
                    .transition(.fade(0.2)),
                    .cacheOriginalImage
                ]
            )
        } else {
            episodeImage.image = UIImage(named: "placeholder")
        }
    }
    
    private func updateFavoriteButton(isFavorite: Bool) {
        let image = isFavorite ? UIImage(named: "heartIconFill") : UIImage(named: "heartIcon")
        heartButton.setImage(image, for: .normal)
    }
    
}
