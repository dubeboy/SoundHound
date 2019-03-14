//
// Created by Divine Dube on 2019-03-12.
// Copyright (c) 2019 Divine Dube. All rights reserved.
//

import Foundation

class ArtistListPresenter: ArtistListPresenterProtocol {


    var view: ArtistListViewProtocol? = nil
    var interactor: ArtistListInteractorInputProtocol? = nil
    var wireFrame: ArtistListWireFrameProtocol? = nil

    func presentArtistsSongs(artists: [ArtistModel]) {
       //TODO Implement some cool stuff here
    }

    func viewDidLoad() {
        view?.showLoading()
        interactor?.retrieveArtists()
    }
}

extension ArtistListPresenter : ArtistsListInteractorOutputProtocol {

    func didRetrieveArtists(artists: [ArtistModel]) {
        view?.hideLoading()
        view?.showArtists(artists: artists)
    }

    func onError() {
        view?.hideLoading()
        view?.showError()
    }
}
