//
// Created by Divine Dube on 2019-03-12.
// Copyright (c) 2019 Divine Dube. All rights reserved.
//

import Foundation

class ArtistListPresenter: ArtistListPresenterProtocol {
    var view: ArtistListViewProtocol?
    var interactor: ArtistListInteractorInputProtocol?
    var wireFrame: ArtistListWireFrameProtocol?

    func presentArtistsSongs(artist: ArtistModel) {
        wireFrame?.presentArtistSongView(from: view!, forArtist: artist)
    }

    func viewDidLoad() {
        view?.showLoading()
        interactor?.retrieveArtists()
    }

    func searchForArtists(by name: String) {
        interactor?.searchForArtist(artistName: name)
    }
}

extension ArtistListPresenter: ArtistsListInteractorOutputProtocol {

    func didRetrieveArtists(artists: [ArtistModel]) {
        view?.hideLoading()
        view?.showArtists(artists: artists)
    }

    func onError() {
        view?.hideLoading()
        view?.showError()
    }
}
