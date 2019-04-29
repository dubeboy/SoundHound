//
//  SongsListUITest.swift
//  SonghoundUITests
//
//  Created by Divine Dube on 2019/03/18.
//  Copyright © 2019 Divine Dube. All rights reserved.
//

import XCTest

class SongsListUITest: XCTestCase {
    
    var app: XCUIApplication!

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test. Doing this in setup will make sure it
        // happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your
        // tests before they run. The setUp method is a good place to do this.
        
        app = XCUIApplication()
        XCTWaiter.wait(for: [XCTestExpectation(description:"")], timeout: 15)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        app = nil
    }
//
//    func testDemoTest() {
//        //waitForExpectations(timeout: 5, handler: {})
////        let goLabel = app.staticTexts["Go!"]
////        XCTAssertFalse(goLabel.exists)
////
////        let exists = NSPredicate(format: "exists == true")
////        expectation(for: exists, evaluatedWithObject: goLabel, handler: nil)
////
////        app.buttons["Ready, set..."].tap()
////        waitForExpectations(timeout: 5, handler: nil)
////        XCTAssert(goLabel.exists)
//    }

    func testMainScreen() {
       XCTAssert(app.navigationBars["🔥Hot Songs & Artists🔥"].exists)
    }
//
//    func testClickSongsArtists() {
//
////
////        let app = XCUIApplication()
////        app.otherElements.containing(.navigationBar, identifier:"Songhound.ArtistListView").children(matching: .other).element.children(matching: .other).element.children(matching: .other).element(boundBy: 1).tap()
////
////        let searchField = app.tables["Empty list"].children(matching: .searchField).element
////        searchField.tap()
////
//        // todo later
//
//
//    }

//    func testOnTopThreeArtistsClicked() {
//
////        app.otherElements
////                .containing(.navigationBar, identifier: "🔥Hot Songs & Artists🔥")
////                .children(matching: .other).element.children(matching: .other).element
////                .children(matching: .other).element.children(matching: .other)
////                .element(boundBy: 1).children(matching: .image).element(boundBy: 0).tap()
////        app.tables.cells.containing(.staticText, identifier: "Delicate").staticTexts["Taylor Swift"].tap()
////
////        XCTAssert(app.staticTexts["Delicate"].exists)
////        XCTAssert(app.staticTexts["reputation"].exists)
////        XCTAssert(app.staticTexts["100 Playes in Joburg"].exists)
//    }
//
    func testSongDetailsScreen() {
        
//        let app = XCUIApplication()
//        app.tables.staticTexts["Taylor Swift"].tap()
//        XCTAssert(app.staticTexts["Blank Space"].exists)
//        XCTAssert(app.staticTexts["1989 (Deluxe)"].exists)
    }
}
