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

    func updateCurrentPlayingSong(songName: String, artistsName: String) {
        interactor?.getSongIDFromiTunes(songName: songName, artistsName: artistsName)
    }

    func retrieveSongsList(for location: String) {
        interactor?.retrieveSongsList(location: location)
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

    // should rename to didUpdate current playing song
    func didReceivePlayingSong(song: SongModel) {
        view?.onSongIDReceived(song: song)
    }
}
