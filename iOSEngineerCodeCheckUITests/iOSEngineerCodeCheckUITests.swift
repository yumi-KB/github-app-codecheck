//
//  iOSEngineerCodeCheckUITests.swift
//  iOSEngineerCodeCheckUITests
//
//  Created by 史 翔新 on 2020/04/20.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import XCTest

class iOSEngineerCodeCheckUITests: XCTestCase {

    override func setUpWithError() throws {
        
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {
        
    }

    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        app.searchFields["リポジトリ名を入力"].tap()
        app.typeText("tetris")
        app/*@START_MENU_TOKEN@*/.buttons["Search"]/*[[".keyboards",".buttons[\"検索\"]",".buttons[\"Search\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.tap()
        sleep(3)
        
        app.tables/*@START_MENU_TOKEN@*/.staticTexts["chvin/react-tetris"]/*[[".cells.staticTexts[\"chvin\/react-tetris\"]",".staticTexts[\"chvin\/react-tetris\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        sleep(3)
        
        app.staticTexts["chvin/react-tetris"].tap()
        app.staticTexts["Written in JavaScript"].tap()
        app.staticTexts["6333 stars"].tap()
        app.staticTexts["6333 watchers"].tap()
        app.staticTexts["1206 forks"].tap()
        app.staticTexts["2 open issues"].tap()
        app.navigationBars["iOSEngineerCodeCheck.DetailView"].buttons["GitHub リポジトリ検索"].tap()
                
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            measure(metrics: [XCTOSSignpostMetric.applicationLaunch]) {
                XCUIApplication().launch()
            }
        }
    }
}
