//
//  FoursquareAPIClientTests.swift
//  FoursquareAPIClientTests
//
//  Created by koogawa on 2015/07/23.
//  Copyright (c) 2015 Kosuke Ogawa. All rights reserved.
//

import UIKit
import XCTest

class FoursquareAPIClientTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        let client = FoursquareAPIClient(accessToken: "accessToken")
        XCTAssertNotNil(client, "FoursquareAPIClient should not be nil")

        let parameter: [String: String] = [
            "query": "Apple",
            "ll": "\(37.33262674912818),\(-122.030451055438)",
        ];

        let expectation = self.expectation(description: "venues/search")

        client.request(path: "venues/search", parameter: parameter) {
            result in
            switch result {
            case let .success(data):
                XCTAssertNotNil(data, "data should not be nil")
                expectation.fulfill()
            case let .failure(error):
                XCTAssertNotNil(error, "error should not be nil")
                expectation.fulfill()
            }
        }

        waitForExpectations(timeout: 1.0) { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure() {
            // Put the code you want to measure the time of here.
        }
    }
    
}
