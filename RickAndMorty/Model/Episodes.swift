//
//  Episodes.swift
//  RickAndMorty
//
//  Created by Vladislav on 23.08.2024.
//

import Foundation

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

struct Character: Codable {
    let image: String
    let name: String
    let species: String
}

struct EpisodeResponse: Codable {
    let info: Info
    let results: [Result]
}
