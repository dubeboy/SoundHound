//
// Created by Divine Dube on 2019-03-13.
// Copyright (c) 2019 Divine Dube. All rights reserved.
//

import Foundation

class ArtistListInteractor: ArtistListInteractorInputProtocol {

    var presenter: ArtistsListInteractorOutputProtocol?
    var remoteDataManager: ArtistListRemoteDataManagerInputProtocolTwo?
    var cache: SearchModel = [:]

    func retrieveArtists() {
        // do logic here bro!
        remoteDataManager?.retrieveArtists()
    }

    // all the logic should be done here man
    func searchForArtist(songName: String, location: String) {
        // NB: debounce
        if !songName.isEmpty && songName.count >= 2 {
            // we dont want to actually do many searches
            let name = songName.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
            let location = location.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
            remoteDataManager?.searchForSongName(songName: name, location: location)
        } else {
            // short circuit suppose to just return a zero sum
            presenter?.didRetrieveArtists(searchResults: cache)
        }
    }

}

extension ArtistListInteractor: ArtistListRemoteDataManagerOutputProtocol {

    func didRetrieveArtists(searchResults: SearchModel) {
        presenter?.didRetrieveArtists(searchResults: searchResults)
        cache = searchResults
    }

    func onError() {
        presenter?.onError()
    }

}
