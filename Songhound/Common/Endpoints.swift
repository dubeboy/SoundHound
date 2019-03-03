//
//  Endpoints.swift
//  Songhound
//
//  Created by Divine Dube on 2019/03/02.
//  Copyright © 2019 Divine Dube. All rights reserved.
//

import Foundation

struct API {
   static let baseURL = ""
}

protocol Endpoint {
    var path: String { get }
    var url: String { get }
}

enum Endpoints {
    enum Songs: Endpoint {
        case fetch
    
        public var path: String {
            switch self {
            case .fetch: return "/getAllPSongs"
         }
        }
        
        public var url: String {
            switch self {
            case .fetch: return "\(API.baseURL)\(path)"
            }
        }
    }
}

