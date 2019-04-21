//
//  Endpoints.swift
//  Songhound
//
//  Created by Divine Dube on 2019/03/02.
//  Copyright © 2019 Divine Dube. All rights reserved.
//

import Foundation

struct API {
    static let baseURL = "https://itunes.apple.com/search?media=music&country=ZA"
    static let vaporCloudAPI = "http://localhost:8080"

}

// this is the structure of how a any url should look like
protocol Endpoint {
    var path: String { get }
    var url: String { get }
}

// these are all my end points
class Endpoints {

    enum SongsEnumEndpoints: Endpoint {
        case fetch(songName: String)
        case fetchSongID(songName: String, artistsName: String)

        // these are functions of this enum!
        public var path: String {
            switch self {
            case .fetch(let songName): return "&entity=song&term=\(songName)"
            case .fetchSongID(let songName, let artistsName): return "&limit=1&entity=song&term=\(songName.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!)+\(artistsName.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!)"
            }
        }

        public var url: String {
            switch self {
            default: return "\(API.baseURL)\(path)"
            }
        }

    }

    enum ArtistsEnumEndpoints: Endpoint {
        case fetch(artistName: String)
        public var path: String {
            switch self {
            case .fetch(let artistName):
                return "&entity=musicArtist&term=\(artistName)"
            }
        }

        public var url: String {
            switch self {
            case .fetch: return "\(API.baseURL)\(path)"
            }
        }
    }
}

