//
//  Artist.swift
//  Songhound
//
//  Created by Divine Dube on 2019/02/19.
//  Copyright © 2019 Divine Dube. All rights reserved.
//

class Artist {
    var name: String = ""
    var numHits: Int
    var isHot: Bool
    
    init(name: String, numHits: Int, isHot: Bool) {
        self.name = name
        self.numHits = numHits
        self.isHot = isHot
    }
}
