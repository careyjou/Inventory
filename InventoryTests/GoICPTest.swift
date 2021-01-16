//
//  CameraPoseTest.swift
//  InventoryTests
//
//  Created by Vincent Spitale on 1/14/21.
//  Copyright © 2021 Vincent Spitale. All rights reserved.
//

import XCTest
@testable import Inventory

class GoICPTest: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testTranslation() throws {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let bundle = Bundle(for: type(of: self))
        guard let desk = bundle.url(forResource: "couch-1", withExtension: "ply"),
            let deskPoints = Utils.pointsFromPLY(url: desk) else {
            throw ParsingError.couldNotLoad
        }
        
        let movedDeskPoints = PointCloud(pointCloud: deskPoints.getPointCloud().map({PointCloudVertex(x: $0.x - 2, y: $0.y - 0.5, z: $0.z + 1, r: $0.r, g: $0.g, b: $0.g)}))
        
        guard let result = GoICPPose().cameraPose(source: deskPoints, destination: movedDeskPoints) else {
            return
        }
        
        
        XCTAssertEqual(-2, result.pose.columns.3.x, accuracy: 0.05)
        XCTAssertEqual(-0.5, result.pose.columns.3.y, accuracy: 0.05)
        XCTAssertEqual(1, result.pose.columns.3.z, accuracy: 0.05)
    }
    
    enum ParsingError: Error {
        case couldNotLoad
    }

}



