//
//  ModelResponse.swift
//  Songhound
//
//  Created by Divine Dube on 2019/03/03.
//  Copyright © 2019 Divine Dube. All rights reserved.
//
import Foundation
import ObjectMapper

struct ModelResponse<T> {
    var resultCount: Int? = 0
    var entityList: [T]? = nil
}

extension ModelResponse: Mappable {
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        resultCount     <- map["resultCount"]
        entityList       <- map["results"]
    }
}
