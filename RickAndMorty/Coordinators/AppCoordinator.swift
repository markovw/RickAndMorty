//
//  AppCoordinator.swift
//  RickAndMorty
//
//  Created by Vladislav on 26.08.2024.
//

import Foundation
import UIKit

class AppCoordinator: Coordinator {
    
    let window: UIWindow

    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        let viewModel = EpisodesViewModel()
        let episodesViewController = EpisodesViewController(viewModel: viewModel)
        
        window.rootViewController = episodesViewController
        window.backgroundColor = .white
    }
}
