//
//  CameraPoseLocalizer.swift
//  Inventory
//
//  Created by Vincent Spitale on 1/7/21.
//  Copyright © 2021 Vincent Spitale. All rights reserved.
//

import Foundation
import MapKit
import CoreData

class CameraPoseLocalizer {
    let data: SpacePointCloudAppData
    let moc: NSManagedObjectContext
    
    init?() {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
              return nil
          }
        
        self.data = appDelegate.data
        self.moc = appDelegate.persistentContainer.viewContext
    }
    
    
    /// <#Description#>
    /// - Parameters:
    ///   - queryPointCloud: <#queryPointCloud description#>
    ///   - location: Device's current location (if available)
    /// - Returns: The camera pose of the world origin in relation to the matched space's point cloud
    public func getCameraPose(queryPointCloud: PointCloud, location: CLLocation?, poseFinder: CameraPoseFinder) -> SpacePoseResult? {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Space")
        
        guard var spaces = try? moc.fetch(fetchRequest) as? [Space] else {
            return nil
        }
        
        if let loc = location {
        spaces.sort(by: {$0.getLocation()?.distance(from: loc) ?? 1000.0 < $1.getLocation()?.distance(from: loc) ?? 1000.0})
        }
        
        for space in spaces {
            guard let referencePointCloud = data.getPointCloud(space: space) else {
                continue
            }
            
            guard let cameraPose = poseFinder.cameraPose(source: referencePointCloud, destination: queryPointCloud) else {
                continue
            }
            
            if cameraPose.confidence > 0.5 {
            return SpacePoseResult(space: space, pose: cameraPose.pose, confidence: cameraPose.confidence)
            }
            
            
        }
        return nil
        
    }
    
    
}


struct SpacePoseResult {
    let space: Space
    let pose: simd_float4x4
    let confidence: Float
}

struct CameraPoseResult {
    let pose: simd_float4x4
    let confidence: Float
}


protocol CameraPoseFinder {
    func cameraPose(source: PointCloud, destination: PointCloud) -> CameraPoseResult?
}
