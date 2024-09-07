//
//  NetworkManager.swift
//  RickAndMorty
//
//  Created by Vladislav on 23.08.2024.
//

import UIKit
import Combine
import Kingfisher

final class NetworkManager {
    func loadData() -> AnyPublisher<EpisodeResponse, NetworkError> {
        guard let url = URL(string: "https://rickandmortyapi.com/api/episode") else {
            return Fail(error: NetworkError.invalidURL)
                .eraseToAnyPublisher()
        }
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { data, response in
                // Проверка статуса HTTP ответа
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    throw NetworkError.invalidResponse
                }
                return data
            }
            .decode(type: EpisodeResponse.self, decoder: JSONDecoder())
            .mapError { error -> NetworkError in
                if error is URLError {
                    return .unknown
                } else if error is DecodingError {
                    return .unknown
                } else {
                    return .unknown
                }
            }
            .eraseToAnyPublisher()
    }
}

final class CharacterFetchService {
    private var cancellables = Set<AnyCancellable>()
    
    func fetchCharacterImage(for characterURL: [String]) -> AnyPublisher<Character, Error> {
        guard let randomCharacterURL = characterURL.randomElement(),
              let url = URL(string: randomCharacterURL) else {
            return Fail(error: NetworkError.invalidURL).eraseToAnyPublisher()
        }
        print(url)
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    throw NetworkError.invalidResponse
                }
                return data
            }
            .decode(type: Character.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}
