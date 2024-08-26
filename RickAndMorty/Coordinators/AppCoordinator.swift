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
        window.rootViewController = EpisodesViewController()
        window.backgroundColor = .white
    }
}
