//
//  OnboardingCoordinator.swift
//  RickAndMorty
//
//  Created by Vladislav on 26.08.2024.
//

import Foundation
import UIKit

final class OnboardingCoordinator: Coordinator {
    
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    var onFinish: (() -> Void)?
    
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let onboardingViewController = OnboardingViewController()
        onboardingViewController.coordinator = self
        
        navigationController.pushViewController(onboardingViewController, animated: false)
    }
    
    func showEpisodes() {
        onFinish?()
    }

}
