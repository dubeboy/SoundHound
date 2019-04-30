//
//  SonghoundUITests.swift
//  SonghoundUITests
//
//  Created by Divine Dube on 2019/03/18.
//  Copyright © 2019 Divine Dube. All rights reserved.
//

import XCTest

class SonghoundUITests: XCTestCase {
    
     var app: XCUIApplication!

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = true

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens
        // for each test method.
        
         app = XCUIApplication()
         app.launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for
        // your tests before they run. The setUp method is a good place to do this.
        XCTWaiter.wait(for: [XCTestExpectation(description:"")], timeout: 7)

        let springboard = XCUIApplication(bundleIdentifier: "com.apple.springboard")
        let allowBtn = springboard.buttons["Allow"]
        if allowBtn.exists {
            allowBtn.tap()
        }
        

    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        app = nil
    }
    
    
    
    func testWarmUP() {
        XCTWaiter.wait(for: [XCTestExpectation(description:"")], timeout: 5)
        XCTAssert(true)
        
    }
    
    
    func testMainScreen() {
        XCTAssert(app.navigationBars["🔥Hot Songs & Artists🔥"].exists)
    }
    
    
    func testSongDetailsScreen() {
        XCTWaiter.wait(for: [XCTestExpectation(description:"")], timeout: 10)

        app.tables.staticTexts["Drive (feat. Delilah Montagu)"].tap()
        let x =  app.otherElements.containing(.navigationBar, identifier:"Songhound.SongDetailView").children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.exists
        
        XCTAssert(x)
    }
    
    func testClickSongsArtists() {
        XCTWaiter.wait(for: [XCTestExpectation(description:"")], timeout: 10)

        app.otherElements.containing(.navigationBar, identifier:"🔥Hot Songs & Artists🔥").children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element(boundBy: 1).children(matching: .image).element(boundBy: 0).tap()
        app.tables.staticTexts["Shake It Off"].tap()
        var x  = app.otherElements.containing(.navigationBar, identifier:"Songhound.SongDetailView").children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.exists
        XCTAssert(x)
    }
    
    
    func testOnClickMoreSongs() {
        XCTWaiter.wait(for: [XCTestExpectation(description:"")], timeout: 7)

        app.buttons["More Songs"].tap()
        let tablesQuery = app.tables
        let searchField = tablesQuery.children(matching: .searchField).element
        searchField.tap()
        searchField.typeText("Bla")
        
        XCTWaiter.wait(for: [XCTestExpectation(description:"")], timeout: 7)
        
        XCUIApplication().tables.staticTexts["Blank Space"].tap()
        
        
        var x =  app.otherElements.containing(.navigationBar, identifier:"Songhound.SongDetailView").children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.exists
        
        XCTAssert(x)
    }

}
