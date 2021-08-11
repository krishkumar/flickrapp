//
//  flickrappTests.swift
//  flickrappTests
//
//  Created by Krishna Kumar on 7/10/21.
//

import XCTest
@testable import flickrapp

class flickrappTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testFlickrInteractor() {
        let appState = AppState()
        let sut = FlickrSearchInteractor(appState: appState)
        sut.load(search: "test", mocked: true)
        print(appState.searchViewModel.photos.photos.photo.count)
        XCTAssert(appState.searchViewModel.photos.photos.photo.count == 0)
    }
}
