//
//  SongsListInterator.swift
//  Songhound
//
//  Created by Divine Dube on 2019/03/01.
//  Copyright © 2019 Divine Dube. All rights reserved.
//

import Foundation
import FirebaseDatabase
// the buss logic goes here
// this protocol can do output input
class SongsListInterator: SongsListInteratorInputProtocol {
  
    
// this is the input Interator so its responsible for actually getting in the input

    var presenter: SongsListInteratorOutputProtocol?
    var localDataManager: SongsListLocalDataManagerInputProtocol?
    var remoteDataManager: SongsListRemoteDataManagerInputProtocol?
    // this is our cache of all the data that we get from the model!
    var cache: [SongModel]?
    var ref: DatabaseReference!

    func retrieveSongsList() {
        remoteDataManager?.retrieveSongsList(path: Endpoints.SongsEnumEndpoints.fetch(songName: "swift").url)
    }
    
    func getSongIDFromiTunes(songName: String, artistsName: String) {
        remoteDataManager?.retrieveSongID(path: Endpoints
                .SongsEnumEndpoints
                .fetchSongID(songName: "swift", artistsName: artistsName).url)
    }

    func getArtist(top selectedId: Int) {
        guard cache != nil, selectedId < cache!.count else {
            return
        }
        // TODO elegant way to force unwrap using the guard statement
        onArtistSelected(artist: cache![selectedId].artist)
    }
}

// output talks to the presenter
extension SongsListInterator: SongsListRemoteDataManagerOutputProtocol {
    func onSongsRetrieved(_ songs: [SongModel]) {
        presenter?.didRetrieveSongs(songs)
        cache = songs
    }

    func onError() {
        presenter?.onError()
    }

    func onArtistSelected(artist: ArtistModel) {
        presenter?.didSelectArtist(artist: artist)
    }

    func onSongIDReceived(song: SongModel) {
        // when we receive one one we should upload it to firebase yoh
        ref = Database.database().reference()
        // create a parent node with id of the song
        let songParentNode = ref.child("\(song.id)")
        songParentNode.observeSingleEvent(of: DataEventType.value) { snap, error in
            if error !=  nil {
                // this means there is an error| meaning ID does not exist
                self.sendSongModelToFirebase(songParentNode: songParentNode, song: song)
            } else {
                let retrievedSong = snap.value as! [String : String]
                var songModel: SongModel!
                songModel.popularity += 1
                self.sendSongModelToFirebase(songParentNode: songParentNode, song: songModel)
            }
        }
        presenter?.didReceivePlayingSong(song: song)
    }

    private func sendSongModelToFirebase(songParentNode: DatabaseReference, song: SongModel) {
        songParentNode.setValue(["songID" : song.id,
                                 "AlbumName": song.albumName,
                                 "ArtistID": song.artist.artistID,
                                 "artworkURL": song.artworkURL,
                                 "name": song.name,
                                 "artistName": song.artistName,
                                 "popularity": song.popularity])
    }
}
