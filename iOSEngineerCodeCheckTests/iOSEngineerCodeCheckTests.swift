//
//  iOSEngineerCodeCheckTests.swift
//  iOSEngineerCodeCheckTests
//
//  Created by 史 翔新 on 2020/04/20.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import XCTest
@testable import iOSEngineerCodeCheck

class iOSEngineerCodeCheckTests: XCTestCase {
    
    override func setUpWithError() throws {
    }
    
    override func tearDownWithError() throws {
    }
    
//    func testExample() throws {
//    }
    
    // apiRequest関数に正しいurlとqueryを渡すとレスポンスが返り値が格納されるのを確認
    func testApiRequest() {
        let vc = SearchViewController()
        vc.apiRequest(url: "https://api.github.com/search/repositories", query: [URLQueryItem(name: "q", value: "tetris")], completion: {
            
            XCTAssertNotNil(vc.repositories)
        })
    }
    
//    func testPerformanceExample() throws {
//        self.measure {
//
//        }
//    }
}
