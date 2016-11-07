//
//  SearchGitHubAPITests.swift
//  SearchGitHubAPITests
//
//  Created by Michał Czerniakowski on 04.11.2016.
//  Copyright © 2016 Michał Czerniakowski. All rights reserved.
//

import XCTest
@testable import SearchGitHubAPI

class SearchGitHubAPITests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
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
    
}
