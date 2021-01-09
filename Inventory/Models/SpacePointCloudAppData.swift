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

final public class SpacePointCloudAppData: ObservableObject {
    
    // key to PointCloud
    private var pointClouds: NSCache<NSString, PointCloud>
    private var cloudQueue: Set<UUID> = Set()
    
    init() {
        let cache: NSCache<NSString, PointCloud> = NSCache()
        
        self.pointClouds = cache
    }
    
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
    
    public func addPointCloud(key: UUID, pointCloud: PointCloud, cloud: Cloud) {
        self.addToCache(key: key, pointCloud: pointCloud)
        
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
