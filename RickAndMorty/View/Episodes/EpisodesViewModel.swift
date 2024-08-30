//
//  EpisodesViewModel.swift
//  RickAndMorty
//
//  Created by Vladislav on 24.08.2024.
//

import Foundation
import Combine
import UIKit

class EpisodesViewModel {
    @Published var episodes: [Result] = []
    @Published var episodeImages: [Character] = []
    private var networkManager: NetworkManager = NetworkManager()
    private var characterFetcher: CharacterFetcher = CharacterFetcher()
    var cancellables = Set<AnyCancellable>()
    
    func loadEpisodes() {
        networkManager.loadData()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("Successfully fetched episodes")
                case .failure(let error):
                    print("Failed to fetch episodes: \(error)")
                }
            }, receiveValue: { [weak self] episodeResponse in
                self?.episodes = episodeResponse.results
                self?.fetchCharacterInfo()
            })
            .store(in: &cancellables)
    }
    
    private func fetchCharacterInfo() {
        for episode in episodes {
            characterFetcher.fetchRandomCharacterImage(for: episode.characters)
                .sink { completion in
                    switch completion {
                    case .finished:
                        print("Successfully fetched \(completion)")
                    case .failure(let error):
                        print("Failed to fetch episodes: \(error)")
                    }
                } receiveValue: { [weak self] character in
                    self?.episodeImages.append(character)
//                    print("Received Character object:")
//                    print("Name: \(character.name)")
//                    print("Image URL: \(character.image)")
//                    print("Species: \(character.species)")
                }
                .store(in: &cancellables)
        }
    }
}
