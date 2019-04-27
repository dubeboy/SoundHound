//
// Created by Divine Dube on 2019-04-27.
// Copyright (c) 2019 Divine Dube. All rights reserved.
//

import UIKit
@testable import Songhound
import XCTest

class ArtistPresenterTest : XCTestCase  {

    var view: MockArtistListView?
    var interactor: MockArtistListInteractorInput?
    var wireFrame: MockArtistListWireFrame?
    var presenter: ArtistListPresenter?
    override func setUp() {
        super.setUp()
        view = MockArtistListView()
        interactor = MockArtistListInteractorInput()
        wireFrame = MockArtistListWireFrame()
        presenter = ArtistListPresenter()

        presenter?.interactor = interactor
        presenter?.wireFrame = wireFrame
        presenter?.view = view

    }

    override func tearDown() {
        super.tearDown()
        view = nil
        interactor = nil
        wireFrame = nil
        presenter = nil
    }

    func testViewDidLoad() {
        //MARK: TODO: This function does not do anything
        presenter?.viewDidLoad()
        XCTAssert(true)
    }

    func testSearchForSongs() {
        presenter?.searchForSongs(songName: "Blank Space", location: "Cape Town")
        XCTAssert(interactor!.songName == "Blank Space")
        XCTAssert(interactor!.location == "Cape Town")
    }

    func testDidRetrieveArtist() {
        presenter?.didRetrieveArtists(searchResults: [:])
       XCTAssert(view?.isLoading == false)
       XCTAssert(view?.searchModel!.count == 0)
    }

    func testOnError() {
        presenter?.onError()
        XCTAssert(view?.isLoading == false)
        XCTAssert(view?.isShowingError == true)

    }
}
