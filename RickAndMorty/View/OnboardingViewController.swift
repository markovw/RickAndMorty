//
//  OnboardingView.swift
//  RickAndMorty
//
//  Created by Vladislav on 26.08.2024.
//

import Foundation
import UIKit

class OnboardingViewController: UIViewController {
    var coordinator: OnboardingCoordinator?
    
    let logoImage: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.image = .logo
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let portalImage: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.image = .loading
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(logoImage)
        view.addSubview(portalImage)
        rotateAndScaleImage()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            self.coordinator?.showEpisodes()
        }
        
        NSLayoutConstraint.activate([
            logoImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 97),
            logoImage.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 10),
            logoImage.widthAnchor.constraint(equalToConstant: 312),
            logoImage.heightAnchor.constraint(equalToConstant: 104),
            
            portalImage.topAnchor.constraint(equalTo: logoImage.bottomAnchor, constant: 146),
            portalImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            portalImage.widthAnchor.constraint(equalToConstant: 200),
            portalImage.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    // MARK: Animation
    private func rotateAndScaleImage() {
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotationAnimation.fromValue = 0
        rotationAnimation.toValue = Double.pi * 2
        rotationAnimation.duration = 1.5
        rotationAnimation.repeatCount = .infinity
        
        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimation.fromValue = 1.0
        scaleAnimation.toValue = 1.2
        scaleAnimation.autoreverses = true
        scaleAnimation.repeatCount = .infinity
        
        let animationGroup = CAAnimationGroup()
        animationGroup.animations = [rotationAnimation, scaleAnimation]
        animationGroup.duration = 4
        animationGroup.repeatCount = .infinity
        
        portalImage.layer.add(animationGroup, forKey: "rotateAndScaleAnimation")
    }
}

