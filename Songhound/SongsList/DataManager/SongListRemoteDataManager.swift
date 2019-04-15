//
//  SongListRemoteDataManager.swift
//  Songhound
//
//  Created by Divine Dube on 2019/03/02.
//  Copyright © 2019 Divine Dube. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper
import FirebaseDatabase


class SongListRemoteDataManager: SongsListRemoteDataManagerInputProtocol {
    // this protocol is the one responsible for sending data the presenter
    var remoteRequestHandler: SongsListRemoteDataManagerOutputProtocol?

    func retrieveSongsList(location: String) {
        // first retrieve all the nodes with the current location
        // then look into their IDs then use that to download the song node off of firebase
        // add that to a tableview list
        //TODO injectable
        let ref = Database.database().reference()
        let locationParentNode = ref.child("\(location)")

        // todo: change this to just observe
        locationParentNode.observeSingleEvent(of: DataEventType.value) { snap, error in
            // these snaps are songs id snaps so
            guard error == nil else {
                print("SLDataManager: There was an error peeps, trying to get song for location")
                self.remoteRequestHandler?.onError()
                return
            }
            var songs: [SongModel] = []
            //todo upload genre
            for child in snap.children  {
                let songIDDictSnap = child as! DataSnapshot
                print()
                let songIDDict = songIDDictSnap.value as! UInt
                // now we need to look for songs with this ID
                ref.child("\(songIDDict)").observeSingleEvent(of: DataEventType.value) { songSnap, error in
                    let songDict = songSnap.value as! [String : AnyObject]
                    let songModel = SongModel(id: songDict["ArtistID"] as! UInt,
                            name: songDict["name"] as! String,
                            artistName: songDict["artistName"] as! String,
                            albumName: songDict["AlbumName"] as! String,
                            genre: "",
                            popularity: songDict["popularity"] as! Int,
                            artworkURL: songDict["artworkURL"] as! String,
                            artist: ArtistModel(name: songDict["artistName"] as! String, artistID: songDict["ArtistID"] as! UInt ))
                    songs.append(songModel)
                    if songs.count == snap.childrenCount {
                        // call up the stack
                        self.remoteRequestHandler?.onSongsRetrieved(songs)
                    }
                }
            }
        }
    }

    func retrieveSongID(path: String) {
        Alamofire
                .request(path, method: .get)
                .responseObject { (response: DataResponse<ModelResponse<SongModel>>) in
                    switch response.result {
                    case .success(let res):
                        if let songs = res.entityList {
                            self.remoteRequestHandler?.onSongIDReceived(song: songs.first!)
                        } else {
                            // should probably pass back an error type yoh
                            self.remoteRequestHandler?.onError()
                        }
                    case .failure(let error):
                        print(error)
                        self.remoteRequestHandler?.onError()
                    }
                }
    }
}
