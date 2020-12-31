//
//  PointCloud.swift
//  Inventory
//
//  Created by Vincent Spitale on 11/1/20.
//  Copyright © 2020 Vincent Spitale. All rights reserved.
//

import Foundation

public class PointCloud: Codable {
    private var pointCloud: [PointCloudVertex]
    
    init(pointCloud: [PointCloudVertex]) {
        self.pointCloud = pointCloud
    }
    

    
    public func getPointCloud() -> [PointCloudVertex] {
        return self.pointCloud
    }
}


