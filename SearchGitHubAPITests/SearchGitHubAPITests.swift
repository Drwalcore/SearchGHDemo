//
//  SearchGitHubAPITests.swift
//  SearchGitHubAPITests
//
//  Created by Michał Czerniakowski on 09.11.16.
//  Copyright © 2016 Michał Czerniakowski. All rights reserved.
//

import XCTest
@testable import SearchGitHubAPI
import UIKit

class SearchGitHubAPITests: XCTestCase {

    var viewController: ViewController!
    
    override func setUp() {
        super.setUp()
        viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ViewController") as! ViewController
    }
    
    func testUIForNil() {
        XCTAssertNil(viewController.tableView, "Table view should be nil")
        let _ = viewController.view
        XCTAssertNotNil(viewController.tableView, "Table view shouldn't be nil")
    }
    
    func testUsersFetchOperation() {
        let mockDataProvider = MockDataProvider()
        viewController.dataProvider = mockDataProvider
        viewController.startSearch(withText: "tt")
        XCTAssert(mockDataProvider.searchStarted, "Search should start")
    }
    
    func testConnection(){
        
        
        let realURLString = "https://api.github.com/search/repositories"
        
        let finalURL = NSURL(string: realURLString)
        let expectedResult = expectation(description: "Get \(finalURL)")
        
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: finalURL! as URL){data, response, error in
            XCTAssertNotNil(data, "data should not be nil")
            XCTAssertNil(error, "error should be nil")
            
            if let HTTPResponse = response as? HTTPURLResponse,
                let responseURL = HTTPResponse.url,
                let MIMEType = HTTPResponse.mimeType{
                
                XCTAssertEqual(responseURL.absoluteString, finalURL!.absoluteString, "HTTP response URL should be equal to original URL")
                //              XCTAssertEqual(HTTPResponse.statusCode, 200, "HTTP response status code should be 200")
                //               XCTAssertNotEqual(HTTPResponse, 404, "Not found")
                //                XCTAssertNotEqual(HTTPResponse, 408, "Timeout from client")
                XCTAssertEqual(MIMEType, "application/json", "HTTP respone content type should be json")
                
            }
            else
            {
                XCTFail("Response was not HTTPURLResponse")
            }
            
            expectedResult.fulfill()
        }
        task.resume()
        
        waitForExpectations(timeout: task.originalRequest!.timeoutInterval) {
            error in
            if let error = error{
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
