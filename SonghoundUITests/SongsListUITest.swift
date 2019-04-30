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
        
        
        XCTWaiter.wait(for: [XCTestExpectation(description:"")], timeout: 3)
        
        let springboard = XCUIApplication(bundleIdentifier: "com.apple.springboard")
        let allowBtn = springboard.buttons["Allow"]
        if allowBtn.exists {
            allowBtn.tap()
        }
        XCTWaiter.wait(for: [XCTestExpectation(description:"")], timeout: 15)

    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        app = nil
    }
    

   
}
