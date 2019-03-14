//
// Created by Divine Dube on 2019-03-13.
// Copyright (c) 2019 Divine Dube. All rights reserved.
//

import Foundation

class ArtistListInteractor : ArtistListInteractorInputProtocol{

    var presenter: ArtistsListInteractorOutputProtocol?
    var remoteDataManager: ArtistListRemoteDataManagerInputProtocol2?
    var cache: [ArtistModel] = []
    func retrieveArtists() {
        // do logic here bro!
        remoteDataManager?.retrieveArtists()
    }

    // all the logic should be done here man
    func searchForArtist(artistName: String) {
        if !artistName.isEmpty && artistName.count >= 3 {
            // we dont want to actually do many searches
            let name = artistName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            remoteDataManager?.searchForArtist(artistName: name)
        } else {
            // short circuit
            presenter?.didRetrieveArtists(artists: cache)
        }
    }

}

extension ArtistListInteractor: ArtistListRemoteDataManagerOutputProtocol {

    func didRetrieveArtists(artists: [ArtistModel]) {
        presenter?.didRetrieveArtists(artists: artists)
        cache = artists
    }

    func onError() {
        presenter?.onError()
    }

}
