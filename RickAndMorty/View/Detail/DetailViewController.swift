//
//  DetailViewController.swift
//  RickAndMorty
//
//  Created by Vladislav on 01.09.2024.
//

import UIKit

class DetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var coordinator: OnboardingCoordinator?

    var data = ["Gender", "Status", "Specie", "Origin", "Type", "Location"]
    var dataDictionary = [String: String]()
    var episode: Result?
    var character: Character?
    
    private let whiteRectangle: UIView = {
        let rect = UIView()
        rect.backgroundColor = .white
        rect.layer.shadowColor = UIColor.black.cgColor
        rect.layer.shadowOpacity = 0.10
        rect.layer.shadowOffset = CGSize(width: 0, height: 2)
        rect.layer.shadowRadius = 2
        rect.translatesAutoresizingMaskIntoConstraints = false
        return rect
    }()
    
    private let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        let image = UIImage(named: "arrowBack")?.resize(to: CGSize(width: 24, height: 24))
        button.imageView?.contentMode = .scaleAspectFit
        button.setImage(image, for: .normal)
        button.setTitle("GO BACK", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.tintColor = .black
        
        return button
    }()
    
    private let logoImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "logoDetail")?.resize(to: CGSize(width: 46, height: 49))
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let circularImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "mockImage")
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 74
        
        imageView.layer.borderColor = UIColor.stroke.cgColor
        imageView.layer.borderWidth = 5

        return imageView
    }()
    
    private let logoCamera: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "logoCamera")?.resize(to: CGSize(width: 32, height: 32)), for: .normal)
        button.contentMode = .scaleAspectFit
        button.tintColor = .black
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let characterName: UILabel = {
        let label = UILabel()
        label.text = "Rick Sanchez"
        label.font = .systemFont(ofSize: 32)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let tableTitle: UILabel = {
        let label = UILabel()
        label.text = "Informations"
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.textColor = .darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    var myTableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDataDictionary()
        view.backgroundColor = .white
        view.addSubview(whiteRectangle)
        view.addSubview(backButton)
        view.addSubview(logoImage)
        view.addSubview(circularImageView)
        view.addSubview(logoCamera)
        view.addSubview(characterName)
        view.addSubview(tableTitle)
        characterName.text = character?.name
        createTable()
        setupHeaderView()
        loadCharacterImage()
        
        self.navigationItem.hidesBackButton = true
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        logoCamera.addTarget(self, action: #selector(imageSwitchTapped), for: .touchUpInside)

    }
    
    func createTable() {
        myTableView = UITableView(frame: view.bounds, style: .plain)
        myTableView.register(DetailTableViewCell.self, forCellReuseIdentifier: "InfoCell")
        myTableView.delegate = self
        myTableView.dataSource = self
        myTableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        myTableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(myTableView)
    }
    
    private func setupDataDictionary() {
        guard let character = character else { return }
        
        dataDictionary = [
            "Gender": character.gender,
            "Status": character.status,
            "Specie": character.species,
            "Origin": character.origin.name.contains("unknown") ? "Unknown" : character.origin.name ,
            "Type": character.type.isEmpty ? "Unknown" : character.type,
            "Location": character.location.name
        ]
    }
    
    private func loadCharacterImage() {
        guard let character = character, let imageURL = URL(string: character.image) else {
            circularImageView.image = UIImage(named: "placeholder")
            return
        }
        
        circularImageView.kf.setImage(
            with: imageURL,
            placeholder: UIImage(named: "placeholder"),
            options: [
                .transition(.fade(0.2)),
                .cacheOriginalImage
            ]
        )
    }
    
    private func setupHeaderView() {
        NSLayoutConstraint.activate([
            whiteRectangle.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            whiteRectangle.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            whiteRectangle.heightAnchor.constraint(equalToConstant: 60),
            whiteRectangle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            
            backButton.leadingAnchor.constraint(equalTo: whiteRectangle.leadingAnchor, constant: 12),
            backButton.topAnchor.constraint(equalTo: whiteRectangle.topAnchor, constant: 18),
            
            logoImage.trailingAnchor.constraint(equalTo: whiteRectangle.trailingAnchor, constant: -21),
            logoImage.topAnchor.constraint(equalTo: whiteRectangle.topAnchor, constant: 6),
            
            circularImageView.topAnchor.constraint(equalTo: whiteRectangle.bottomAnchor, constant: 64),
            circularImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            circularImageView.widthAnchor.constraint(equalToConstant: 148),
            circularImageView.heightAnchor.constraint(equalToConstant: 148),
            
            logoCamera.topAnchor.constraint(equalTo: whiteRectangle.bottomAnchor, constant: 122),
            logoCamera.leadingAnchor.constraint(equalTo: circularImageView.trailingAnchor, constant: 9),
            
            characterName.topAnchor.constraint(equalTo: circularImageView.bottomAnchor, constant: 34),
            characterName.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            tableTitle.topAnchor.constraint(equalTo: characterName.bottomAnchor, constant: 18),
            tableTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            
            myTableView.topAnchor.constraint(equalTo: tableTitle.bottomAnchor, constant: 20),
            myTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            myTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            myTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    @objc private func backButtonTapped() {
        print("Back Button")
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func imageSwitchTapped() {
        let actionSheet = UIAlertController(title: "Upload an image", message: nil, preferredStyle: .actionSheet)
        let action1 = UIAlertAction(title: "Camera", style: .default) { [weak self] _ in
            self?.openCamera()
        }
        let action2 = UIAlertAction(title: "Gallery", style: .default) { [weak self] _ in
            self?.openGallery()
        }
        let action3 = UIAlertAction(title: "Cancel", style: .cancel)
        
        actionSheet.addAction(action1)
        actionSheet.addAction(action2)
        actionSheet.addAction(action3)
        
        present(actionSheet, animated: true, completion: nil)
    }
    
    private func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            imagePicker.allowsEditing = false
            present(imagePicker, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Error", message: "Camera not available", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true)
        }
    }
    
    private func openGallery() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = false
            present(imagePicker, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Error", message: "Photo library not available", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        }
    }
}

// MARK: UITableViewDataSource
extension DetailViewController {
    func numberOfSections(in tableView: UITableView) -> Int {
        6
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InfoCell", for: indexPath) as! DetailTableViewCell
        let key = data[indexPath.section]
        let value = dataDictionary[key] ?? "N/A"

        cell.titleLabel.text = key
        cell.valueLabel.text = value
        
        return cell
    }
}

// MARK: UITableViewDelegate
extension DetailViewController {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        64
    }
}

extension DetailViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.originalImage] as? UIImage {
            circularImageView.image = pickedImage
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
