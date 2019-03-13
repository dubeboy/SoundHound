//
// Created by Divine Dube on 2019-03-13.
// Copyright (c) 2019 Divine Dube. All rights reserved.
//

import Foundation

class ArtistListInteractor : ArtistListInteractorInputProtocol{

    var presenter: ArtistsListInteractorOutputProtocol?
    var remoteDataManager: ArtistListRemoteDataManagerInputProtocol2?
    func retrieveArtists() {
        // do logic here bro!
        remoteDataManager?.retrieveArtists()
    }

    func searchForArtist(artistName: String) {

    }

}

extension ArtistListInteractor: ArtistListRemoteDataManagerOutputProtocol {

    func didRetrieveArtists(artists: [ArtistModel]) {
        presenter?.didRetrieveArtists(artists: artists)
    }

    func onError() {
        presenter?.onError()
    }

}
