//
//  FlickrSearchTests.swift
//  FlickrSearchTests
//
//  Created by jonathan ide on 21/8/21.
//

import XCTest
@testable import FlickrSearch

class FlickrSearchTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testFlickrDataSource() throws {
       let dataSource = FlickrDataSource()
       dataSource.search(for: "kittens")
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
