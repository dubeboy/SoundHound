//
//  ModelResponse.swift
//  Songhound
//
//  Created by Divine Dube on 2019/03/03.
//  Copyright © 2019 Divine Dube. All rights reserved.
//

import Foundation
import ObjectMapper

struct ModelResponse<T: Mappable> {
    var resultCount: Int? = 0
    var entityList: [T]?
}

extension ModelResponse: Mappable {

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {
        resultCount <- map["resultCount"]
        entityList <- map["results"]
    }
}
