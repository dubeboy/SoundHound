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
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        app = nil
    }

    func testDemoTest() {
        //waitForExpectations(timeout: 5, handler: {})
//        let goLabel = app.staticTexts["Go!"]
//        XCTAssertFalse(goLabel.exists)
//
//        let exists = NSPredicate(format: "exists == true")
//        expectation(for: exists, evaluatedWithObject: goLabel, handler: nil)
//
//        app.buttons["Ready, set..."].tap()
//        waitForExpectations(timeout: 5, handler: nil)
//        XCTAssert(goLabel.exists)
    }

    func testMainScreen() {
       XCTAssert(app.navigationBars["🔥Hot Songs & Artists🔥"].exists)
    }

    func testClickMoreArtists() {

        app.buttons["More Artists"].tap()
        
        let tablesQuery = app.tables
        let searchField = tablesQuery.children(matching: .searchField).element
        searchField.tap()
        tablesQuery.cells.containing(.staticText, identifier: "Taylor Swift").staticTexts["6 Hits in your area"].tap()
        tablesQuery.staticTexts["Delicate"].tap()
        app.staticTexts["Delicate"].tap()
        app.staticTexts["reputation"].tap()
        app.staticTexts["100 Playes in Joburg"].tap()
        
        XCTAssert(app.staticTexts["Delicate"].exists)
        XCTAssert(app.staticTexts["reputation"].exists)
        XCTAssert(app.staticTexts["100 Playes in Joburg"].exists)
    }

    func testOnTopThreeArtistsClicked() {
        
        app.otherElements
                .containing(.navigationBar, identifier: "🔥Hot Songs & Artists🔥")
                .children(matching: .other).element.children(matching: .other).element
                .children(matching: .other).element.children(matching: .other)
                .element(boundBy: 1).children(matching: .image).element(boundBy: 0).tap()
        app.tables.cells.containing(.staticText, identifier: "Delicate").staticTexts["Taylor Swift"].tap()
       
        XCTAssert(app.staticTexts["Delicate"].exists)
        XCTAssert(app.staticTexts["reputation"].exists)
        XCTAssert(app.staticTexts["100 Playes in Joburg"].exists)
    }
    
    func testSongDetailsScreen() {
        XCUIApplication().tables.cells
                .containing(.staticText, identifier: "Wildest Dreams").staticTexts["Taylor Swift"].tap()
        XCTAssert(app.staticTexts["Wildest Dreams"].exists)
        XCTAssert(app.staticTexts["1989"].exists)
        XCTAssert(app.staticTexts["100 Playes in Joburg"].exists)
    }
}
