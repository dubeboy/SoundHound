//
//  SongsListViewPresenter.swift
//  Songhound
//
//  Created by Divine Dube on 2019/03/01.
//  Copyright © 2019 Divine Dube. All rights reserved.
//


// so this classes characteristic is defined by this protocol that it inherits from
// this class communicates with the other classes
// get the user response from the View
class SongsListViewPresenter: SongListPresenterProtocol {


    weak var view: SongsListViewProtocol?
    var interactor: SongsListInteratorInputProtocol?
    var wireframe: SongsListViewWireFrameProtocol?

    func viewDidLoad() {
        view?.showLoading()
        interactor?.retrieveSongsList()
    }

    func showSongDetail(forSong song: SongModel) {
        wireframe?.presentSongDetailsScreen(from: view!, forSong: song)
    }

    func showSongs(forSelectedArtistId: Int) {
        interactor?.getArtist(top: forSelectedArtistId)
    }

    func presentMoreArtists() {
        wireframe?.presentMoreArtists(from: view!)
    }
}

extension SongsListViewPresenter: SongsListInteratorOutputProtocol {


    func didRetrieveSongs(_ songs: [SongModel]) {
        view?.hideLoading()
        view?.showSongsList(songs: songs)
    }

    func onError() {
        view?.hideLoading()
        view?.showError()
    }

    func didSelectArtist(artist: ArtistModel) {
        wireframe?.presentSongsListViewScreen(from: view!, forArtist: artist)
    }
}
