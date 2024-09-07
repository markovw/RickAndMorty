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
    @Published var selectedEpisode: (episode: Result, character: Character)?
    var cancellables = Set<AnyCancellable>()
    private var networkManager: NetworkManager
    private var characterFetchService: CharacterFetchService
    
    init(networkManager: NetworkManager, characterFetchService: CharacterFetchService) {
        self.networkManager = networkManager
        self.characterFetchService = characterFetchService
    }
    
    func didSelectEpisode(at indexPath: IndexPath) {
        guard indexPath.row < episodes.count, indexPath.row < episodeImages.count else { return }
        let episode = episodes[indexPath.row]
        let character = episodeImages[indexPath.row]
        selectedEpisode = (episode, character)
    }
    
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
            characterFetchService.fetchCharacterImage(for: episode.characters)
                .sink { completion in
                    switch completion {
                    case .finished:
                        print("Successfully fetched \(completion)")
                    case .failure(let error):
                        print("Failed to fetch episodes: \(error)")
                    }
                } receiveValue: { [weak self] character in
                    self?.episodeImages.append(character)
                }
                .store(in: &cancellables)
        }
    }
    
    func removeEpisode(at index: Int) {
        if index >= 0 && index < episodes.count {
            episodes.remove(at: index)
            episodeImages.remove(at: index)
        }
    }
}
