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
    // should be able to test this when its nil coz it causes lots of problems
    func viewDidLoad() {
        view?.showLoading(forArtist: artist!)
        interactor?.retriveSongsList(artistName: artist!.name) ?? print("this is nil bro deadly nil!!!")
    }

    func showSongDetail(forSong song: SongModel) {
        wireFrame?.presentSongDetailsScreen(from: view!, forSong: song)
    }
}

extension ArtistSongListViewPresenter: ArtistSongsListViewInteractorOutputProtocol {

    func didRetrieveSongs(_ songs: [SongModel]) {
        view?.hideLoading()
        view?.showSongs(with: songs)
    }

    func onError() {
        view?.hideLoading()
        view?.showError()
    }


}