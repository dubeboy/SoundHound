//
//  Song.swift
//  Songhound
//
//  Created by Divine Dube on 2019/02/17.
//  Copyright © 2019 Divine Dube. All rights reserved.
//

class Song {
    var name: String
    var artistName: String
    var albumName: String
    var genre: String
    var popularity: Int
    var albumId: Int64
    
    init( name: String,  artistName: String, genre: String, popularity: Int, albumName: String,  albumId: Int64) {
        self.name = name
        self.artistName = artistName
        self.genre = genre  // TODO change spelling
        self.popularity = popularity
        self.albumName = albumName
        self.albumId = albumId
    }

}
