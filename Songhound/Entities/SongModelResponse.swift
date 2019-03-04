//
//  SongModelResponse.swift
//  Songhound
//
//  Created by Divine Dube on 2019/03/03.
//  Copyright © 2019 Divine Dube. All rights reserved.
//
import Foundation
import ObjectMapper

struct SongModelResponse {
    var resultCount: Int? = 0
    var songs: [SongModel]? = nil
}

extension SongModelResponse: Mappable {
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        resultCount     <- map["resultCount"]
        songs       <- map["results"]
    }
}
