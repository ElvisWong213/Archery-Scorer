//
//  Archery_ScorerUITests.swift
//  Archery ScorerUITests
//
//  Created by Elvis on 9/6/2022.
//

import XCTest

class Archery_ScorerUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testButton() throws {
        let app = XCUIApplication()
        app.launch()
        
        let home = app.buttons["homeButton"]
        let add = app.buttons["addButton"]
        let statistic = app.buttons["statisticButton"]
        
        XCTAssert(home.exists)
        XCTAssert(add.exists)
        XCTAssert(statistic.exists)
    }
    
    func testAddData() throws {
        let app = XCUIApplication()
        app.launch()
        
        app.buttons["addButton"].tap()
        
        let distance = app.textFields["distance"]
        distance.tap()
        distance.typeText("10")
        
        XCTAssertNotEqual(distance.value as! String, "")
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
