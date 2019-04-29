//
//  ArtistListInteractorTest.swift
//  SonghoundTests
//
//  Created by Divine Dube on 2019/04/27.
//  Copyright © 2019 Divine Dube. All rights reserved.
//

import XCTest
@testable import Songhound

class ArtistListInteractorTest: XCTestCase {

    var presenter: MockArtistsListInteractorOutput?
    var remoteDataManager: MockArtistListRemoteDataManagerInput?
    var cache: SearchModel = [:]
    var interactor: ArtistListInteractor?

    override func setUp() {
        interactor = ArtistListInteractor()
        remoteDataManager = MockArtistListRemoteDataManagerInput()
        presenter = MockArtistsListInteractorOutput()
        interactor?.remoteDataManager = remoteDataManager
        interactor?.presenter = presenter
    }

    override func tearDown() {
        remoteDataManager = nil
        presenter = nil
        interactor?.presenter = nil
        interactor?.remoteDataManager = nil
        interactor = nil
    }


    func testRetrieveArtist() {
        //this method does nothing
        interactor?.retrieveArtists()

        XCTAssert(true)

    }

    func testSearchForArtistSongNameNotEmpty() {
        interactor?.searchForArtist(songName: "Blank Space", location: "Cape Town")
        XCTAssert(remoteDataManager?.songName != nil)
        XCTAssert(remoteDataManager?.location != nil)
    }

    func testSearchForArtistSongNameEmpty() {
        interactor?.searchForArtist(songName: "", location: "Cape Town")
        XCTAssert(presenter!.retrievedArtist)
    }

    func testDidRetrieveArtists() {
        interactor!.didRetrieveArtists(searchResults: [:])
        XCTAssert(presenter!.retrievedArtist)
    }

    func testOnError() {
        interactor?.onError()
        XCTAssert(presenter!.showingError)
    }
}

