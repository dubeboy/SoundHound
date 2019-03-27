//
// Created by Divine Dube on 2019-03-22.
// Copyright (c) 2019 Divine Dube. All rights reserved.
//

import XCTest
@testable import Songhound
import Alamofire

protocol ExpectationFulFillerProtocol {
    func fulFill(expectation: XCTestExpectation)
}

class SongsListDataManagerTest: XCTestCase, ExpectationFulFillerProtocol {

    var songsListDataManager: SongListRemoteDataManager!
    var mockTestSongListInteractor: MockTestSongListInteractor!
    var server = Server.getServerInstance()  // start server

    override func setUp() {
        super.setUp()
        songsListDataManager = SongListRemoteDataManager()
        mockTestSongListInteractor = MockTestSongListInteractor()
        mockTestSongListInteractor.expectationFulFiller = self
        mockTestSongListInteractor.remoteDataManager = songsListDataManager
        songsListDataManager.remoteRequestHandler = mockTestSongListInteractor
    }

    override func tearDown() {
        super.tearDown()
        songsListDataManager.remoteRequestHandler = nil
        mockTestSongListInteractor.expectationFulFiller = nil
        mockTestSongListInteractor.expectation = nil
        mockTestSongListInteractor.songs = nil
        songsListDataManager = nil
        mockTestSongListInteractor = nil
    }

//    func testServer() {
//        let expectation = XCTestExpectation(description: "Download song")
//        let url = URL(string: MockEndpoints.MockSongsEnumEndpoints.fetch().url)
//
//        let task: URLSessionDataTask = URLSession.shared.dataTask(with: url!) { (data, response, error) in
//            guard let data = data else { print("ooops"); return }
//            print("baddd response: ")
//            print(String(data: data, encoding: .utf8)!)
//            print("done")
//        }
//
//        task.resume()
//        wait(for: [expectation], timeout: 10.0)
//    }

    func testDidGetData() {
        // leave default path
        let expectation = XCTestExpectation(description: "Retrieve Songs List")
        mockTestSongListInteractor.expectation = expectation
        mockTestSongListInteractor.retrieveSongsList()
        wait(for: [expectation], timeout: 10)
        let songs = mockTestSongListInteractor.songs
        XCTAssertNotNil(songs)
    }

    func testEmptySongsList() {
        let expectation = XCTestExpectation(description: "Retrieve Empty Songs List")
        mockTestSongListInteractor.expectation = expectation
        mockTestSongListInteractor.endpoit = MockEndpoints.MockEmptySongsEnumEndpoints.fetch.url
        mockTestSongListInteractor.retrieveSongsList()
        wait(for: [expectation], timeout: 10)
        let songs = mockTestSongListInteractor.songs
        XCTAssertNotNil(songs) // but empty
    }

    func testOnSongsReturnError() {
        mockTestSongListInteractor.endpoit = MockEndpoints.MockErrorSongsEnumEndpoints.fetch.url
        mockTestSongListInteractor.retrieveSongsList()
        let songs = mockTestSongListInteractor.songs
        XCTAssertNil(songs)
    }

    func testMalformedRequest() {
        mockTestSongListInteractor.endpoit = MockEndpoints.MockEmptyMalformedSongsEnumEndpoints.fetch.url
        mockTestSongListInteractor.retrieveSongsList()
        let songs = mockTestSongListInteractor.songs
        XCTAssertNil(songs)
    }

    func fulFill(expectation: XCTestExpectation) {
        print("full filling")
       // expectation.fulfill()
    }
}
