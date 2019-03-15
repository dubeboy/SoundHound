//
// Created by Divine Dube on 2019-03-08.
// Copyright (c) 2019 Divine Dube. All rights reserved.
//


// So here we testing the presenter! and we mock out the other parts

import Foundation
import XCTest
@testable import Songhound // bring all the Songhound classes so that we can easily test man

class SongListPresenterTests: XCTestCase {
    private var presenter: (SongListPresenterProtocol & SongsListInteratorOutputProtocol)!
    private var interactor: MockTestSongListInteractor!
    private var wireFrame: MockTestSongListWireFrame!
    private var remoteDataManager: MockTestSongListRemoteDataManager!
    private var view: MockSongsListViewController!

    // begin unit genesis
    override func setUp() {
        super.setUp()
        interactor = MockTestSongListInteractor()
        wireFrame = MockTestSongListWireFrame()
        remoteDataManager = MockTestSongListRemoteDataManager()
        view = MockSongsListViewController()
        // since we testing the presenter it makes sense to have a concrete class of the presenter
        presenter = SongsListViewPresenter()
        view.presenter = presenter
        presenter.view = view
        presenter.wireframe = wireFrame
        presenter.interactor = interactor
        interactor.presenter = presenter
        interactor.remoteDataManager = remoteDataManager
        remoteDataManager.remoteRequestHandler = interactor

        presenter.viewDidLoad()

    }

    override func tearDown() {
        super.tearDown()

        //pop stack
        presenter.wireframe = nil
        presenter.interactor = nil
        interactor.presenter = nil
        interactor.remoteDataManager = nil
        view.presenter = nil
        presenter.view = nil
        remoteDataManager.remoteRequestHandler = nil
        view = nil
        interactor = nil
        wireFrame = nil
        remoteDataManager = nil
        presenter = nil // since we testing the presenter it makes sense to have a concrete class of the presenter

    }

    func testViewDidLoad() {
        XCTAssertTrue(view.isLoading)
    }

    func testDidShowDetailScreen() {
        //presenter.sho(from: view, forArtist: ArtistModel(name: "Taylor Swift", artistID: 200000))
        presenter.showSongDetail(forSong: SongModel(id: 100,
                name: "UOK",
                artistName: "Nasty C", 
                albumName: "Single", 
                genre: "Hip Hop",
                popularity: 100,
                artworkURL: "exmpleUrl.com/assets/image.jpg", 
                artist: ArtistModel(name: "Taylor Swift", artistID: 200000)))

        XCTAssert(wireFrame.showSongDetailCalled)
    }

    func testShowSongs() {
        presenter.showSongs(forSelectedArtistId: 0)
        XCTAssertNotNil(wireFrame.artist)
    }

    func testShowsErrorOnError() {
        // simulate network error
        remoteDataManager.songs = nil
        presenter.viewDidLoad() // initiaste all the seqence of getting the data
        XCTAssertTrue(view.isShowingError)
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}