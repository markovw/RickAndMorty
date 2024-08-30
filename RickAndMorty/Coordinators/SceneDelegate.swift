//
//  SceneDelegate.swift
//  RickAndMorty
//
//  Created by Vladislav on 23.08.2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    private var appCoordinator: AppCoordinator?
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {

        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            let applicationCoordinator = AppCoordinator(window: window, UINavigationController())
            applicationCoordinator.start()
            self.appCoordinator = applicationCoordinator
            window.makeKeyAndVisible()

        }
    }

}
