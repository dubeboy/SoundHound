//
// Created by Divine Dube on 2019-03-11.
// Copyright (c) 2019 Divine Dube. All rights reserved.
//

import UIKit
@testable import Songhound

class MockTestSongListInteractor: SongsListInteratorInputProtocol, SongsListRemoteDataManagerOutputProtocol {


    var presenter: SongsListInteratorOutputProtocol?
    var localDataManager: SongsListLocalDataManagerInputProtocol?
    var remoteDataManager: SongsListRemoteDataManagerInputProtocol?


    func onSongsRetrieved(_ songs: [SongModel]) {
        presenter?.didRetrieveSongs(songs)
    }

    func onArtistSelected(artist: ArtistModel) {
        presenter?.didSelectArtist(artist: artist)
    }

    func onError() {
        presenter?.onError()
    }


    func retrieveSongsList() {
        remoteDataManager?.retrieveSongsList()
    }

    func getArtist(top selectedId: Int) {
        onArtistSelected(artist: ArtistModel(name: "Taylor Swift", artistID: 200000))
    }
}

class MockTestSongListWireFrame: SongsListViewWireFrameProtocol {

    var showSongDetailCalled = false
    var presentSongsListViewScreen = false
    var view: SongsListViewProtocol!
    var song: SongModel!
    var artist: ArtistModel!

    static func createSongsListModule() -> UIViewController {
        return UIViewController()
    }

    func presentSongDetailsScreen(from view: SongsListViewProtocol, forSong song: SongModel) {
        showSongDetailCalled = true
        self.view = view
        self.song = song
    }

    func presentSongsListViewScreen(from view: SongsListViewProtocol, forArtist artist: ArtistModel) {
        presentSongsListViewScreen = true
        self.artist = artist
    }

    // clean up
    deinit {
        view = nil
        song = nil
        artist = nil
    }

    func presentMoreArtists(from view: SongsListViewProtocol) {

    }
}

class MockTestSongListRemoteDataManager: SongsListRemoteDataManagerInputProtocol {

    var remoteRequestHandler: SongsListRemoteDataManagerOutputProtocol?

    var songs: [SongModel]? = [SongModel(id: 100, name: "Blank Space", artistName: "Taylor Swift", albumName: "Single", genre: "Hip Hop", popularity: 100, artworkURL: "exampleUrl.com/assets/image.jpg", artist: ArtistModel(name: "Taylor Swift", artistID: 200000))]

    func retrieveSongsList() {
        // simulate network error
        if let songs = songs {
            remoteRequestHandler?.onSongsRetrieved(songs)
        } else {
            remoteRequestHandler?.onError()
        }
    }
}

class MockSongsListViewController: SongsListViewProtocol {

    var isLoading = false
    var isHidden = false
    var isShowingError = false
    var songs: [SongModel]?

    var presenter: SongListPresenterProtocol?

    func showSongsList(songs: [SongModel]) {
        self.songs = songs
    }

    func onTopThreeArtistClicked() {

    }

    func showLoading() {
        isLoading = true
    }

    func showError() {
        isShowingError = true
    }

    func hideLoading() {
        isHidden = false
    }


    deinit {
        print("deinit TestSongsListViewController")
        songs = nil
    }
}


class MockSongsListViewPresenter: SongListPresenterProtocol, SongsListInteratorOutputProtocol {


    var view: SongsListViewProtocol?
    var interactor: SongsListInteratorInputProtocol?
    var wireframe: SongsListViewWireFrameProtocol?

    var cache: [SongModel]? = nil

    func didRetrieveSongs(_ songs: [SongModel]) {
        cache = songs
        view?.hideLoading()
        view?.showSongsList(songs: songs)
    }

    func didSelectArtist(artist: ArtistModel) {
        wireframe?.presentSongsListViewScreen(from: view!, forArtist: artist)

    }

    func onError() {
        view?.showError()
    }

    func viewDidLoad() {
        interactor?.retrieveSongsList()
    }

    func showSongDetail(forSong song: SongModel) {
        wireframe?.presentSongDetailsScreen(from: view!, forSong: song)
    }

    func showSongs(forSelectedArtistId: Int) {
        wireframe?.presentSongsListViewScreen(from: view!, forArtist: ArtistModel(name: "John", artistID: 1000))
    }

    func presentMoreArtists() {

    }


}


