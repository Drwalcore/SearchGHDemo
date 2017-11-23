@testable import SearchGitHubAPI
import XCTest
import UIKit

class SearchGitHubAPITests: XCTestCase {

    var viewController: MainViewController!

    override func setUp() {
        super.setUp()
        viewController = MainViewController()
    }

    func testUIForNil() {
        //XCTAssertNil(viewController.mainView.tableView, "Table view should be nil")
        _ = viewController.view
        XCTAssertNotNil(viewController.mainView.tableView, "Table view shouldn't be nil")
    }

    func testRandomLettersFetchOperation() {
        let mockDataProvider = MockDataProvider()
        viewController.dataProvider = mockDataProvider
        viewController.startSearch(withText: "tt")
        XCTAssert(mockDataProvider.searchStarted, "Search should start")
    }

    func testRealUserNameFetchOperation() {
        let mockDataProvider = MockDataProvider()
        viewController.dataProvider = mockDataProvider
        viewController.startSearch(withText: "Drwalcore")
        XCTAssert(mockDataProvider.searchStarted, "Search should start")
    }

    func testConnection() {

        let realURLString = "https://api.github.com/search/repositories"

        let finalURL = NSURL(string: realURLString)
        let expectedResult = expectation(description: "Get \(finalURL)")

        let session = URLSession.shared

        let task = session.dataTask(with: finalURL! as URL) {data, response, error in
            XCTAssertNotNil(data, "data should not be nil")
            XCTAssertNil(error, "error should be nil")

            if let HTTPResponse = response as? HTTPURLResponse,
                let responseURL = HTTPResponse.url,
                let MIMEType = HTTPResponse.mimeType {

                XCTAssertEqual(responseURL.absoluteString, finalURL!.absoluteString, "HTTP response URL should be equal to original URL")
                //              XCTAssertEqual(HTTPResponse.statusCode, 200, "HTTP response status code should be 200")
                //               XCTAssertNotEqual(HTTPResponse, 404, "Not found")
                //                XCTAssertNotEqual(HTTPResponse, 408, "Timeout from client")
                XCTAssertEqual(MIMEType, "application/json", "HTTP respone content type should be json")

            } else {
                XCTFail("Response was not HTTPURLResponse")
            }

            expectedResult.fulfill()
        }
        task.resume()

        waitForExpectations(timeout: task.originalRequest!.timeoutInterval) {
            error in
            if let error = error {
                print("Error:\(error.localizedDescription)")
            }

            task.cancel()
        }

    }

    override func tearDown() {
        super.tearDown()
    }

}

class MockDataProvider: MockDataProviderProtocol {
    var searchStarted = false

    func startSearch() {
        searchStarted = true
    }

}
