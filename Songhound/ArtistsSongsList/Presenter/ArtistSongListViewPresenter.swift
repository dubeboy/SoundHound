//
//  ArtistSongListViewPresenter.swift
//  Songhound
//
//  Created by Divine Dube on 2019/03/04.
//  Copyright © 2019 Divine Dube. All rights reserved.
//

import Foundation

class ArtistSongListViewPresenter: ArtistSongsListViewPresenterProtocol {
    var view: ArtistsListViewProtocol?
    var interactor: ArtistSongsListViewInteractorInputProtocol?
    var wireFrame: ArtistsListViewWireFrameProtocol?
    var artist: ArtistModel?

    // begin genesis
    func viewDidLoad() {
        view?.showLoading(forArtist: artist!)
        interactor?.retriveSongsList(artistName: artist!.name)
    }
}
