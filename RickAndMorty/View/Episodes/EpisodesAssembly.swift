//
//  EpisodesAssembly.swift
//  RickAndMorty
//
//  Created by Vladislav on 05.09.2024.
//

import UIKit

final class EpisodesAssembly {
    static func configure(_ dependencies: IDependency) -> UIViewController {
        return dependencies.moduleContainer.getEpisodesView()
    }
}
