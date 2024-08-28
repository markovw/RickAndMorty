//
//  EpisodeView.swift
//  RickAndMorty
//
//  Created by Vladislav on 26.08.2024.
//

import Foundation
import UIKit

final class EpisodeCellView: UICollectionViewCell {
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
    
    let heartIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(episodeImage)
        contentView.addSubview(episodeTitle)
        contentView.addSubview(characterName)
        contentView.addSubview(episodeIcon)
        contentView.addSubview(heartIcon)
        
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
            
            heartIcon.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -18),
            heartIcon.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -14),
            heartIcon.widthAnchor.constraint(equalToConstant: 41),
            heartIcon.heightAnchor.constraint(equalToConstant: 40),
            
            characterName.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            characterName.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            characterName.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -83)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
