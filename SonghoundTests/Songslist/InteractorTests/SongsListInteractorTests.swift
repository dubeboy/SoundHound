//
// Created by Divine Dube on 2019-03-11.
// Copyright (c) 2019 Divine Dube. All rights reserved.
//

import XCTest
@testable import Songhound

class SongsListInteractorTest: XCTestCase {

    var presenter: MockSongsListViewPresenter!
    var interactor: (SongsListInteratorInputProtocol & SongsListRemoteDataManagerOutputProtocol)!
    var wireFrame: MockTestSongListWireFrame!
    var remoteDataManager: MockTestSongListRemoteDataManager!
    var view: MockSongsListViewController!

    //TODO some instantiation is not really required
    override func setUp() {
        super.setUp()
        interactor = SongsListInterator()
        wireFrame = MockTestSongListWireFrame()
        remoteDataManager = MockTestSongListRemoteDataManager()
        view = MockSongsListViewController()
        presenter = MockSongsListViewPresenter()
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
        interactor = nil
        wireFrame = nil
        remoteDataManager = nil
        view = nil
        presenter = nil
    }

    func testInputRetrieveSongsList() {
        presenter.viewDidLoad()
        XCTAssertNotNil(presenter.cache)
    }

    func testInputGetTopArtist() {
        presenter.viewDidLoad()
        interactor.getArtist(top: 0)
        XCTAssertTrue(wireFrame.presentSongsListViewScreen)
    }

    func testOutputOnError() {
        remoteDataManager.songs = nil
        presenter.viewDidLoad()
        XCTAssertTrue(view.isShowingError)
    }
    
    func testGetSongIDFromItunesWithSpace() {
        presenter.viewDidLoad()
        interactor.getSongIDFromiTunes(songName: "Blank Space", artistsName: "Taylor Swift")
        let songPathWithSpace = Endpoints
            .SongsEnumEndpoints
            .fetchSongID(songName: "Blank Space", artistsName: "Taylor Swift").url
        XCTAssert(remoteDataManager.path == songPathWithSpace)
       
       }
    
    func testGetSongIDFromItunesWithoutSpace() {
        presenter.viewDidLoad()
        interactor.getSongIDFromiTunes(songName: "Blank", artistsName: "Taylor")
        let songPathWithoutSpace = Endpoints
            .SongsEnumEndpoints
            .fetchSongID(songName: "Blank", artistsName: "Taylor").url
        
        XCTAssert(remoteDataManager.path == songPathWithoutSpace)

    }
    
    func testGetArtists() {
         presenter.viewDidLoad()
         interactor.getArtist(top: 0)
         XCTAssert(presenter.selectedArtist != nil)
    }
    
    func testGetArtistsWhenNoSuchArtistDoesNotExist() {
        presenter.viewDidLoad()
        interactor.getArtist(top: 1)
        XCTAssert(presenter.selectedArtist == nil)
    }
}
