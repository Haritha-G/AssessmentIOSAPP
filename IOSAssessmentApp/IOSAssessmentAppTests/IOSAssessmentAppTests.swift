//
//  IOSAssessmentAppTests.swift
//  IOSAssessmentAppTests
//
//  Created by HarithaReddy on 24/07/18.
//  Copyright © 2018 administrator. All rights reserved.
//

import XCTest
@testable import IOSAssessmentApp

class IOSAssessmentAppTests: XCTestCase {
    
    func test_NetworkConnectivity()
    {
        if !ReachabilityManager.sharedInstance.isNetworkAvailable()
        {
            XCTFail("Internet Connection required to get data")
        }
    }
    func test_request_withUrl() {
        guard let _ = URL(string: "https://dl.dropboxusercontent.com/s/2iodh4vg0eortkl/facts.json") else {
            fatalError("URL String is not valid")
        }
        ParserHelper.getData { (canadaPlace, error) in
            if error != nil
            {
                XCTFail("Unable to get data from the url")
            }
        }
       
        }
    
   
    func test_downloadWithExpectation()
    {
        
        let expect = expectation(description: "Download should succeed")
        if let _ = URL(string: "https://dl.dropboxusercontent.com/s/2iodh4vg0eortkl/facts.json"){
            ParserHelper.getData(completionHandler: { (canadaPlace, error) in
                XCTAssertNil(error , "Unexpected error occurred :\(String(describing: error?.localizedDescription))")
                XCTAssertNotNil(canadaPlace , "No data Returned")
                expect.fulfill()
            })
        }
        
        waitForExpectations(timeout: 10) { (error) in
            XCTAssertNil(error, "Test timed out.\(String(describing: error?.localizedDescription))")
        }
    }
    
}

