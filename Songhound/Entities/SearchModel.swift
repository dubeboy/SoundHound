//
//  SearchModel.swift
//  App
//
//  Created by Divine Dube on 2019/04/17.
//

import Foundation

typealias SearchModel = [String: SearchModelValue]

struct SearchModelValue: Codable {
    var id: UInt?
    var name: String
    var songID: UInt
}
