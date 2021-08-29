//
//  FlickrSearchTests.swift
//  FlickrSearchTests
//
//  Unit and Async Integration Tests
// 
//  Created by jonathan ide on 21/6/21.
//

import XCTest
import RxSwift
@testable import FlickrSearch

class FlickrSearchTests: XCTestCase {

    func testValidTermFlickrDataSource() throws {
        let dataSource = FlickrDataSource()
        let expectation = XCTestExpectation(description: "get kitten data")
        dataSource.search(for: "Kittens", page: 1) { data in
            XCTAssertTrue(!data.isEmpty, "no data found when there should be some")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10, enforceOrder: true)
    }
    
    func testInvalidTermFlickrDataSource() throws {
        let dataSource = FlickrDataSource()
        let expectation = XCTestExpectation(description: "empty term should not return data")
        dataSource.search(for: "", page: 1) { data in
            print("Data: \(data)")
            XCTAssertTrue(data.isEmpty, "data found when there should not be any")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 20, enforceOrder: true)
    }
    
    func testInvalidTermModel() throws {
        let dataSource = FlickrDataSource()
        let searchModel = SearchModel(dataSource: dataSource)
        let expectation = XCTestExpectation(description: "empty term should not return data")
        _ = searchModel.search(for: "", page: 1).subscribe { results in
            if let data = results.element {
                XCTAssertTrue(data.isEmpty, "data found when there should not be any")
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 20, enforceOrder: true)
    }
    
    func testValidTermModel() throws {
        let dataSource = FlickrDataSource()
        let searchModel = SearchModel(dataSource: dataSource)
        let expectation = XCTestExpectation(description: "term return data")
        _ = searchModel.search(for: "Kittens", page: 1).subscribe { results in
            if let data = results.element {
                XCTAssertTrue(!data.isEmpty, "no data found when there should be some")
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 20, enforceOrder: true)
    }
    
    func testValidTermViewModel() throws {
        let dataSource = FlickrDataSource()
        let searchModel = SearchModel(dataSource: dataSource)
        let searchViewModel = SearchViewModel(model: searchModel)
        let expectation = XCTestExpectation(description: "term return data")
        _ = searchViewModel.search(for: "Kittens", page: 1).subscribe { results in
            if let data = results.element {
                XCTAssertTrue(!data.isEmpty, "no data found when there should be some")
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 20, enforceOrder: true)
    }
    
    func testInvalidTermViewModel() throws {
        let dataSource = FlickrDataSource()
        let searchModel = SearchModel(dataSource: dataSource)
        let searchViewModel = SearchViewModel(model: searchModel)
        let expectation = XCTestExpectation(description: "no data returned")
        _ = searchViewModel.search(for: "", page: 1).subscribe { results in
            if let data = results.element {
                XCTAssertTrue(data.isEmpty, "data found when there should be none")
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 20, enforceOrder: true)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
