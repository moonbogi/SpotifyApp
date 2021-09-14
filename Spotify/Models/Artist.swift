//
//  Artist.swift
//  Spotify
//
//  Created by Leo Moon on 2021-09-03.
//

import Foundation

struct Artist: Codable {
    let id: String
    let name: String
    let type: String
    let images: [APIImage]?
    let external_urls: [String: String]
}
