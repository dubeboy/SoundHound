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

    override func setUp() {
        super.setUp()

        interactor = MockTestSongListInteractor()
        wireFrame = MockTestSongListWireFrame()
        remoteDataManager = MockTestSongListRemoteDataManager()
        view = MockSongsListViewController()
        // since we testing the presenter it makes sense to have a concrete class of the presenter
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


}
