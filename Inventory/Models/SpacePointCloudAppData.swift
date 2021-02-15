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


/// Stores point cloud data for fast lookup using a cache.
final public class SpacePointCloudAppData: ObservableObject {
    
    // key to PointCloud
    private var pointClouds: NSCache<NSString, PointCloud>
    private var cloudQueue: Set<UUID> = Set()
    
    init() {
        let cache: NSCache<NSString, PointCloud> = NSCache()
        
        self.pointClouds = cache
    }
    
    
    /// Get the point cloud associated to the given space if it has been loaded.
    /// - Parameter space: Query space
    /// - Returns: Pptional point cloud capture
    public func getPointCloud(space: Space) -> PointCloud? {
        if let id = space.getPointCloud()?.id {
            if !cloudQueue.contains(id) && (pointClouds.object(forKey: NSString(string: id.uuidString)) == nil) {
                DispatchQueue.global(qos: .userInitiated).async {
                    self.addCloud(space: space)
                }
            }
            
            return pointClouds.object(forKey: NSString(string: id.uuidString))
        }
        return nil
    }
    
    
    /// Add the captured point cloud to the space's cloud and add it to the cache.
    /// - Parameters:
    ///   - key: Lookup key
    ///   - pointCloud: Point cloud data
    ///   - cloud: Cloud object
    public func addPointCloud(key: UUID, pointCloud: PointCloud, cloud: Cloud) {
        self.addToCache(key: key, pointCloud: pointCloud)
        
        let encoder = JSONEncoder()
        
        let data = try? encoder.encode(pointCloud)
        
        DispatchQueue.main.async {
            cloud.setPointCloud(pointCloud: data)
        }
        
    }
    
    /// Begin decoding the space of this space if it is not in the cache or queue.
    /// - Parameter space: Space whose point cloud will be decoded
    public func addCloud(space: Space) {
        if let cloud = space.pointCloud,
           let id = cloud.id,
           let data = cloud.pointCloud {
            guard (pointClouds.object(forKey: NSString(string: id.uuidString)) == nil) else {
                return
            }
            
            cloudQueue.insert(id)
            
            let decoder = JSONDecoder()
            if let pointCloud = try? decoder.decode(PointCloud.self, from: data) {
                self.addToCache(key: id, pointCloud: pointCloud)
            }
        }
    }
    
    
    /// Add the point to the cache with the given lookup key which is the cloud id.
    /// - Parameters:
    ///   - key: lookup key
    ///   - pointCloud: Point cloud data
    private func addToCache(key: UUID, pointCloud: PointCloud) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else {
                return
            }
            
            self.pointClouds.setObject(pointCloud, forKey: NSString(string: key.uuidString))
            self.cloudQueue.remove(key)
            self.objectWillChange.send()
        }
    }
    
}
