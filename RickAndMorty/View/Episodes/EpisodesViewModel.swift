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
    @Published var searchText: String = "" {
        didSet {
            filterEpisodes()
        }
    }
    
    private var cancellables = Set<AnyCancellable>()
    private var networkManager: NetworkManager
    private var characterFetchService: CharacterFetchService
    
    private var allEpisodes: [Result] = []
    private var allEpisodeImages: [Character] = []
    
    private func filterEpisodes() {
        if searchText.isEmpty {
            episodes = allEpisodes
            episodeImages = allEpisodeImages
        } else {
            let filteredIndices = zip(allEpisodes, allEpisodeImages).enumerated().compactMap { index, pair in
                let (episode, character) = pair
                let episodeMatch = episode.name.lowercased().contains(searchText.lowercased())
                let episodeContentMatch = episode.episode.lowercased().contains(searchText.lowercased())
                let characterMatch = character.name.lowercased().contains(searchText.lowercased())
                return (episodeMatch || episodeContentMatch || characterMatch) ? index : nil
            }
            episodes = filteredIndices.map { allEpisodes[$0] }
            episodeImages = filteredIndices.map { allEpisodeImages[$0] }
        }
    }
    
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
                guard let self = self else { return }
                self.allEpisodes = episodeResponse.results
                self.episodes = self.allEpisodes
                self.fetchCharacterInfo()
            })
            .store(in: &cancellables)
    }
    
    private func fetchCharacterInfo() {
        let group = DispatchGroup()
        for episode in allEpisodes {
            group.enter()
            characterFetchService.fetchCharacterImage(for: episode.characters)
                .sink { completion in
                    switch completion {
                    case .finished:
                        print("Successfully fetched character image")
                    case .failure(let error):
                        print("Failed to fetch character image: \(error)")
                    }
                    group.leave()
                } receiveValue: { [weak self] character in
                    self?.allEpisodeImages.append(character)
                }
                .store(in: &cancellables)
        }
        group.notify(queue: .main) { [weak self] in
            self?.episodeImages = self?.allEpisodeImages ?? []
            self?.filterEpisodes()
        }
    }
    
    func removeEpisode(at index: Int) {
        if index >= 0 && index < episodes.count {
            episodes.remove(at: index)
            episodeImages.remove(at: index)
        }
    }
}
