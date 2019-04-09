//
//  ShowMusicServicesTests.swift
//  ShowMusicServicesTests
//
//  Created by Dave Henke on 8/10/18.
//  Copyright © 2018 ShowPad, NV. All rights reserved.
//

import XCTest
@testable import ShowMusicServices

class ShowMusicServicesTests: XCTestCase {
    func testSuccessfulImageDownload() {
        let expectation = XCTestExpectation(description: "Async image loading")
        guard let bundle = Bundle(identifier: "com.musicapp.ShowMusicServices"), let path = bundle.path(forResource: "10", ofType: "jpg"), let pulledData = try? Data(contentsOf: URL(fileURLWithPath: path)) else {
            XCTAssert(false)
            expectation.fulfill()
            return
        }
        MusicLibrary.shared.downloadAlbumCover(identifier: 10) { (response) in
            switch response {
            case .success(let data):
                XCTAssert(data == pulledData)
            case .failure(_):
                XCTAssert(false)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testFailedImageDownload() {
        let expectation = XCTestExpectation(description: "Async image loading")
        MusicLibrary.shared.downloadAlbumCover(identifier: 100) { (response) in
            switch response {
            case .success(_):
                XCTAssert(false)
            case .failure(_):
                XCTAssert(true)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testDataExists() {
        guard let bundle = Bundle(identifier: "com.musicapp.ShowMusicServices"), let path = bundle.path(forResource: "data", ofType: "json") else {
            XCTAssert(false)
            return
        }
        let pulledData = try? Data(contentsOf: URL(fileURLWithPath: path))
        XCTAssert(pulledData != nil)
    }
}
