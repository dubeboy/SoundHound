//
//  SongsListInterator.swift
//  Songhound
//
//  Created by Divine Dube on 2019/03/01.
//  Copyright © 2019 Divine Dube. All rights reserved.
//

import Foundation

// the buss logic goes here
// this protocol can do output input
class SongsListInterator: SongsListInteratorInputProtocol {
// this is the input Interator so its responsible for actually getting in the input

    var presenter: SongsListInteratorOutputProtocol?
    var localDataManager: SongsListLocalDataManagerInputProtocol?
    var remoteDataManager: SongsListRemoteDataManagerInputProtocol?
    // this is our cache of all the data that we get from the model!
    var cache: [SongModel]?

    func retrieveSongsList() {
        remoteDataManager?.retrieveSongsList(path: Endpoints.SongsEnumEndpoints.fetch(songName: "swift").url)
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
}
