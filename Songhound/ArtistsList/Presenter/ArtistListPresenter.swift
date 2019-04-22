//
// Created by Divine Dube on 2019-03-12.
// Copyright (c) 2019 Divine Dube. All rights reserved.
//

import Foundation

class ArtistListPresenter: ArtistListPresenterProtocol {


    var view: ArtistListViewProtocol?
    var interactor: ArtistListInteractorInputProtocol?
    var wireFrame: ArtistListWireFrameProtocol?

    func presentSongDetails(song: SearchModelValue) {
        wireFrame?.presentSongDetailView(from: view!, forSong: song)
    }

    func viewDidLoad() {
        view?.showLoading()
        interactor?.retrieveArtists()
    }

    func searchForSongs(songName: String, location: String) {
        interactor?.searchForArtist(songName: songName, location: location)
    }
}

extension ArtistListPresenter: ArtistsListInteractorOutputProtocol {

    func didRetrieveArtists(searchResults: SearchModel) {
        view?.hideLoading()
        view?.showArtists(searchResults: searchResults)
    }

    func onError() {
        view?.hideLoading()
        view?.showError()
    }
}
