//
//  HeaderView.swift
//  RickAndMorty
//
//  Created by Vladislav on 26.08.2024.
//

import Foundation
import UIKit

final class HeaderCellView: UICollectionViewCell {
    
    let logoImageView = UIImageView()
    let searchTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Name or episode (ex.S01E01)..."
        textField.backgroundColor = .white
        textField.borderStyle = .roundedRect
        textField.textColor = .textButton
        textField.translatesAutoresizingMaskIntoConstraints = false
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
        return filterButton
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(logoImageView)
        contentView.addSubview(searchTextField)
        contentView.addSubview(filterButton)
        
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        filterButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // logo
            logoImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            logoImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            logoImageView.heightAnchor.constraint(equalToConstant: 104),
            logoImageView.widthAnchor.constraint(equalToConstant: 312),
            
            // searchbar
            searchTextField.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 66),
            searchTextField.widthAnchor.constraint(equalToConstant: 312),
            searchTextField.heightAnchor.constraint(equalToConstant: 40),
            
            // button
            filterButton.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 13),
            filterButton.widthAnchor.constraint(equalToConstant: 312),
            filterButton.heightAnchor.constraint(equalToConstant: 56)
        ])
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
