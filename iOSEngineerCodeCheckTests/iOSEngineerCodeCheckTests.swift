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
        let api = APIClient(queryItems: [URLQueryItem(name: "q", value: "tetris")])
        guard let url = api.getRequestURL() else { return }
        api.request(url: url, completion: { object in
            XCTAssertNotNil(vc.repositories)
        })
    }
    
//    func testPerformanceExample() throws {
//        self.measure {
//
//        }
//    }
}
