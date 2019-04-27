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
    
    var song: SongModel!

    // begin unit genesis
    override func setUp() {
        super.setUp()
        song = SongModel(id: 100, name: "UOK", artistName: "Nasty C", albumName: "Single", genre: "Hip Hop",
                         popularity: 100, artworkURL: "exmpleUrl.com/assets/image.jpg",
                         artist: ArtistModel(name: "Taylor Swift", artistID: 200000))
        
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
        
        song = nil
    }

    func testViewDidLoad() {
        XCTAssertTrue(view.isLoading)
    }

    func testDidShowDetailScreen() {
        //presenter.sho(from: view, forArtist: ArtistModel(name: "Taylor Swift", artistID: 200000))
        presenter.showSongDetail(
                forSong: song)

        XCTAssert(wireFrame.showSongDetailCalled)
    }

    func testShowSongs() {
        presenter.showSongs(forSelectedArtistId: 0)
        XCTAssertNotNil(wireFrame.artist)
    }

    func testPresenterShowMoreArtistsScreen() {
        presenter.presentMoreArtists()
        XCTAssert(wireFrame.didPresentMoreArtists == true)
    }
    
    func testupdateCurrentPlayingSong() {
        presenter.updateCurrentPlayingSong(songName: "Blank", artistsName: "Swift")
        XCTAssert(interactor.songName != nil)
        XCTAssert(interactor.artistsName != nil)
    }
    
    func testRetrieveSongsListForLocation() {
        presenter.retrieveSongsList(for: "JHB")
        XCTAssert(interactor.location == "JHB")
    }
    
    func testOnError() {
        presenter.onError()
        XCTAssert(view.isLoading == true)
        XCTAssert(view.isHidden == false)
    }
    
    func testIfDidSelectetArtist() {
        presenter.didSelectArtist(artist: ArtistModel(name: "Swift", artistID: 0))
        XCTAssert(wireFrame.presentSongsListViewScreen == true)
    }
    
    func testOnSongsIDRecieved() {
        presenter.didReceivePlayingSong(song: song)
        XCTAssert(view.songIDRecieved == true)
    }
}

