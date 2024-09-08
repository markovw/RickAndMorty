//
//  Episodes.swift
//  RickAndMorty
//
//  Created by Vladislav on 23.08.2024.
//

import Foundation

struct EpisodeDTO {
    let id: Int
    let name: String
    let airDate: String
    let episode: String
    let characterName: String
    let characterImage: String
    let characterStatus: String
    let characterSpecies: String
    let characterGender: String
    let characterLocation: String
    let characterOrigin: String
    let characterType: String
}

struct Info: Codable {
    let count: Int
    let pages: Int
    let next: String
}

struct Result: Codable, Identifiable {
    let id: Int
    let name: String
    let airDate: String
    let episode: String
    let characters: [String]
    let url: String
    let created: String
    
    enum CodingKeys: String, CodingKey {
        case id, name
        case airDate = "air_date"
        case episode, characters, url, created
    }
}

struct Location: Codable {
    let name: String
}

struct Origin: Codable {
    let name: String
}

struct Character: Codable {
    let image: String
    let name: String
    let status: String
    let species: String
    let gender: String
    let location: Location
    let origin: Origin
    let type: String
}

struct EpisodeResponse: Codable {
    let info: Info
    let results: [Result]
}

extension EpisodeDTO {
    init(from result: Result, character: Character) {
        self.id = result.id
        self.name = result.name
        self.airDate = result.airDate
        self.episode = result.episode
        self.characterName = character.name
        self.characterImage = character.image
        self.characterStatus = character.status
        self.characterSpecies = character.species
        self.characterGender = character.gender
        self.characterLocation = character.location.name
        self.characterOrigin = character.origin.name
        self.characterType = character.type

    }
}
