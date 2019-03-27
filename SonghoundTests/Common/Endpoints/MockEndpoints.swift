//
//  Endpoints.swift
//  Songhound
//
//  Created by Divine Dube on 2019/03/02.
//  Copyright © 2019 Divine Dube. All rights reserved.
//
//TODO Should better this please!!!!!! duplicated code why
import Foundation

struct MockAPI {
    static let baseURL = "http://localhost:8080/"
}
// this is the structure of how a any url should look like
// these are all my end points
class MockEndpoints {

    enum MockSongsEnumEndpoints: Endpoint {
        case fetch

        // these are functions of this enum!
        public var path: String {
            switch self {
            case .fetch: return "get_songs"
            }
        }

        public var url: String {
            switch self {
            case .fetch: return "\(MockAPI.baseURL)\(path)"
            }
        }
    }

    enum MockErrorSongsEnumEndpoints: Endpoint {
        case fetch

        // these are functions of this enum!
        public var path: String {
            switch self {
            case .fetch: return "error"
            }
        }

        public var url: String {
            switch self {
            case .fetch: return "\(MockAPI.baseURL)\(path)"
            }
        }
    }

    enum MockEmptySongsEnumEndpoints: Endpoint {
        case fetch

        // these are functions of this enum!
        public var path: String {
            switch self {
            case .fetch: return "get_empty"
            }
        }

        public var url: String {
            switch self {
            case .fetch: return "\(MockAPI.baseURL)\(path)"
            }
        }
    }

    enum MockEmptyMalformedSongsEnumEndpoints: Endpoint {
        case fetch

        // these are functions of this enum!
        public var path: String {
            switch self {
            case .fetch: return "get_empty_object"
            }
        }

        public var url: String {
            switch self {
            case .fetch: return "\(MockAPI.baseURL)\(path)"
            }
        }
    }

    enum MockArtistsEnumEndpoints: Endpoint {
        case fetch
        public var path: String {
            switch self {
            case .fetch:
                return "get_artists"
            }
        }

        public var url: String {
            switch self {
            case .fetch: return "\(MockAPI.baseURL)\(path)"
            }
        }
    }
}

