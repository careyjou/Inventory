//
//  AppData.swift
//  Inventory
//
//  Created by Vincent Spitale on 6/27/20.
//  Copyright © 2020 Vincent Spitale. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

final public class AppData: ObservableObject {
    
    // key to PointCloud
    @Published public var pointClouds: Dictionary<UUID, PointCloud> = Dictionary()
    private var pointCloudQueue = Set<String>()
    
    public func getPointCloud(space: Space) -> PointCloud? {
        if let id = space.getPointCloud()?.id {
            return pointClouds[id]
        }
        return nil
    }
    
    public func addPointCloud(key: UUID, pointCloud: PointCloud, cloud: Cloud) {
        pointClouds[key] = pointCloud
        
        let encoder = JSONEncoder()
        
        let data = try? encoder.encode(pointCloud)
        
        DispatchQueue.main.async {
            cloud.pointCloud = data
        }
        
    }
    
    public func addCloud(space: Space) {
        if let cloud = space.pointCloud,
           let id = cloud.id,
           let data = cloud.pointCloud {
            guard (pointClouds[id] == nil) else {
                return
            }
            
            let decoder = JSONDecoder()
            if let pointCloud = try? decoder.decode(PointCloud.self, from: data) {
                DispatchQueue.main.async {
                    self.pointClouds[id] = pointCloud
                }
            }
        }
    }
    
}
