//
//  ArtistModel.swift
//  Songhound
//
//  Created by Divine Dube on 2019/03/04.
//  Copyright © 2019 Divine Dube. All rights reserved.
//

import Foundation
import ObjectMapper

// woo I am loving structs
struct ArtistModel {
    var name: String = ""
    var artistID: UInt = 0
}

extension ArtistModel: Mappable {
    init?(map: Map) {}

    mutating func mapping(map: Map) {
        name <- map["artistName"]
        artistID <- map["artistId"]
    }


}
