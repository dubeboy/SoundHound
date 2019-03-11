//
// Created by Divine Dube on 2019-03-08.
// Copyright (c) 2019 Divine Dube. All rights reserved.
//


// So here we testing the presenter! and we mock out the other parts

import Foundation
import XCTest
@testable import Songhound // bring all the Songhound classes so that we can easily test man

class SongListPresenterTests: XCTestCase {
    var presenter: (SongListPresenterProtocol & SongsListInteratorOutputProtocol)!
    var interactor: MockTestSongListInteractor!
    var wireFrame: MockTestSongListWireFrame!
    var remoteDataManager: SongsListRemoteDataManagerInputProtocol!
    var view: TestSongsListViewController!

    // begin unit genesis
    override func setUp() {
        super.setUp()
        interactor = MockTestSongListInteractor()
        wireFrame = MockTestSongListWireFrame()
        remoteDataManager = MockTestSongListRemoteDataManager()
        view = TestSongsListViewController()
        // since we testing the presenter it makes sense to have a concrete class of the presenter
        presenter = SongsListViewPresenter()
        view.presenter = presenter
        presenter.view = view
        presenter.wireframe = wireFrame
        presenter.interactor = interactor
        interactor.presenter = presenter
        interactor.remoteDataManager = remoteDataManager
        remoteDataManager.remoteRequestHandler = interactor

    }

    override func tearDown() {
        super.tearDown()

        view = nil
        interactor = nil
        wireFrame = nil
        remoteDataManager = nil
        presenter = nil // since we testing the presenter it makes sense to have a concrete class of the presenter
//        presenter.wireframe = nil
//        presenter.interactor = nil
//        interactor.presenter = nil
//        interactor.remoteDataManager = nil
        //        view.presenter = nil
        //        presenter.view = nil
//        remoteDataManager.remoteRequestHandler = nil
    }

    func testViewDidLoad() {
        presenter.viewDidLoad()
        XCTAssertTrue(view.isLoading)
    }

    func testDidShowDetailScreen() {
        //presenter.sho(from: view, forArtist: ArtistModel(name: "Taylor Swift", artistID: 200000))
        presenter.showSongDetail(forSong: SongModel(id: 100, name: "UOK", artistName: "Nasty C", albumName: "Single", genre: "Hip Hop", popularity: 100, artworkURL: "exmpleUrl.com/assets/image.jpg", artist: ArtistModel(name: "Taylor Swift", artistID: 200000)))
        XCTAssert(wireFrame.showSongDetailCalled)
    }

    func testShowSongs() {
        presenter.showSongs(forSelectedArtistId: 0)
        XCTAssertNotNil(wireFrame.artist)
    }

    // could also test if the
    // need to test the error cases!!

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    

    

}

// MY MOCKS

extension SongListPresenterTests {
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
    class MockTestSongListWireFrame: SongsListViewWireFrameProtocol  {

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
    }
    class MockTestSongListRemoteDataManager:  SongsListRemoteDataManagerInputProtocol {

        var remoteRequestHandler: SongsListRemoteDataManagerOutputProtocol?

        func retrieveSongsList() {
            remoteRequestHandler?.onSongsRetrieved([SongModel(id: 100, name: "Blank Space", artistName: "Taylor Swift", albumName: "Single", genre: "Hip Hop", popularity: 100, artworkURL: "exampleUrl.com/assets/image.jpg", artist: ArtistModel(name: "Taylor Swift", artistID: 200000))])
        }
    }
    class TestSongsListViewController : SongsListViewProtocol {

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
}
// must also add the output protocol bro

