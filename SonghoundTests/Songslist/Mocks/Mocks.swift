//
// Created by Divine Dube on 2019-03-11.
// Copyright (c) 2019 Divine Dube. All rights reserved.
//

//swiftlint:disable trailing_whitespace

import UIKit
import XCTest
@testable import Songhound

class MockTestSongListInteractor: SongsListInteratorInputProtocol, SongsListRemoteDataManagerOutputProtocol {

    var presenter: SongsListInteratorOutputProtocol?
    var localDataManager: SongsListLocalDataManagerInputProtocol?
    var remoteDataManager: SongsListRemoteDataManagerInputProtocol?
    var endpoit: String = MockEndpoints.MockSongsEnumEndpoints.fetch.url
    var expectation: XCTestExpectation?
    var expectationFulFiller: ExpectationFulFillerProtocol?

    var songs: [SongModel]? = nil {
        didSet {
            expectationFulFiller?.fulFill(expectation: expectation!)
        }

    }

    func onSongsRetrieved(_ songs: [SongModel]) {
        self.songs = songs
        presenter?.didRetrieveSongs(songs)
    }

    func onArtistSelected(artist: ArtistModel) {
        presenter?.didSelectArtist(artist: artist)
    }

    func onError() {
        presenter?.onError()
    }

    func retrieveSongsList() {
        print("the path is : \(endpoit)")
        remoteDataManager?.retrieveSongsList(location: endpoit)
    }

    func getArtist(top selectedId: Int) {
        onArtistSelected(artist: ArtistModel(name: songs?[selectedId].name ?? "", artistID: 00))
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

    var songs: [SongModel]? =  [
        SongModel(id: 100, name: "Blank Space", artistName: "Taylor Swift", albumName: "Single", genre: "Hip Hop", 
                popularity: 100, artworkURL: "exampleUrl.com/assets/image.jpg",
                artist: ArtistModel(name: "Taylor Swift", artistID: 200000))]

    func retrieveSongsList(location: String) {
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

    var cache: [SongModel]?

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
