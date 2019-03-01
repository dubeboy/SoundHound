//
//  SongModel.swift
//  Songhound
//
//  Created by Divine Dube on 2019/03/01.
//  Copyright © 2019 Divine Dube. All rights reserved.
//

import Foundation
import ObjectMapper

struct SongModel {
    var id = 0
    var name: String = ""
    var artistName: String = ""
    var albumName: String = ""
    var genre: String = ""
    var popularity: Int = 0
    var artworkURL: String = ""
}

extension SongModel: Mappable {
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        id      <- map["id"]
        name       <- map["title"]
        artworkURL      <- map["artworkURL"]
        artistName      <- map["artistName"]
        albumName       <- map["albumName"]
        genre       <- map["genre"]
    }
}
