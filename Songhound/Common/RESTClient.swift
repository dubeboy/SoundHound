//
// Created by Divine Dube on 2019-02-25.
// Copyright (c) 2019 Divine Dube. All rights reserved.
//


import Alamofire
import SwiftyJSON

fileprivate let BASE_URL = "https://itunes.apple.com/search?media=music&entity=song"

func getArtist(songId: Int) {
    
}

func getTopSongs(response: @escaping (_ songs: [Song]) -> Void) {
    
}

// return an array of songs
func searchForSongByArtist(songName: String, callback: @escaping (_ songs: [Song]) -> Void) {
    var songs: [Song] = []
    Alamofire.request(BASE_URL + "&term=\(songName)")
        .responseJSON(completionHandler: { response in
            switch response.result {
            case .success(let json):
                let resArray = JSON(json)["results"] // fix this line looks bad
                for i in 0...50 {
                    let artistName = resArray[i]["artistName"].stringValue
                    let albumName = resArray[i]["collectionName"].stringValue
                    let trackName = resArray[i]["trackName"].stringValue
                    let artworkURL = resArray[i]["artworkUrl100"].stringValue
                    let genre = resArray[i]["primaryGenreName"].stringValue
                    let song = Song(name: trackName, artistName: artistName, genre: genre, popularity: 10, albumName: albumName, artworkURL: artworkURL)
                    
                    songs.append(song)
                }
                print("the json response from apple is \(response)")
                callback(songs)
                
            case .failure(let error):
                print(error)
            }
        })
}

func searchAlbumCoverFromMusicBrainz(songName: String) {
    
}
