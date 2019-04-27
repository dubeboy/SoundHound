//
//  SongDetailsTest.swift
//  SonghoundTests
//
//  Created by Divine Dube on 2019/04/27.
//  Copyright © 2019 Divine Dube. All rights reserved.
//

import XCTest
@testable import Songhound
import FirebaseDatabase

class SongDetailsTest: XCTestCase {

    var view: MockSongDetailsView?
    var wireframe: MockSongDetailWireFrame?
    var songFull: SongModel?
    var song: SongModel?
    var ref: DatabaseReference!
    // TEST SUBJECT
    var presenter: SongDetailPresenterProtocol?
    
    override func setUp() {
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        
        songFull = SongModel(id: 100, name: "UOK", artistName: "Nasty C", albumName: "Single", genre: "Hip Hop",
                         popularity: 100, artworkURL: "exmpleUrl.com/assets/image.jpg",
                         artist: ArtistModel(name: "Taylor Swift", artistID: 200000))
        
        song =  SongModel(id: 100, name: "UOK", artistName: "", albumName: "Single", genre: "Hip Hop",
                          popularity: 100, artworkURL: "exmpleUrl.com/assets/image.jpg",
                          artist: ArtistModel(name: "Taylor Swift", artistID: 200000))
        
       view = MockSongDetailsView()
       wireframe = MockSongDetailWireFrame()
       presenter = SongDetailPresenter()
       presenter?.view = view
       presenter?.wireframe = wireframe
       view?.presenter = presenter
        
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        songFull = nil
        song = nil
        presenter?.wireframe = nil
         view?.presenter = nil
         wireframe = nil
         presenter?.view = nil
         view = nil
         presenter = nil
    }
    
    func testViewDidLoadWithFullSongDetailsPresent() {
        presenter!.song = songFull
        presenter?.viewDidLoad()
        
        XCTAssert(view?.isNotLoading == true)
        XCTAssert(view?.song != nil )
    }
    
    func testViewDidLoadWithoutFullSongDetailsPresent() {
        presenter?.song = song
        presenter?.viewDidLoad()
        //MARK: TODO: Cannot test firebase
        
        XCTAssert(true)
    }
}
