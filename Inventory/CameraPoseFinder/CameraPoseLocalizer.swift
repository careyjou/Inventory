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


/// A system to query what the device's camera pose from the world origin is within one of many spaces.
class CameraPoseLocalizer {
    let moc: NSManagedObjectContext
    
    init?() {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
            // should not initialize if the point cloud data and managed context cannot be accessed
              return nil
          }
        
        self.moc = appDelegate.persistentContainer.viewContext
    }
    
    
    /// Queries a point cloud and an optional location against the localizer's space and point cloud data
    /// to find the device's camera pose with 6 degrees of freedom.
    /// - Parameters:
    ///   - queryPointCloud: The captured point cloud to be localized
    ///   - location: Device's current location (if available)
    /// - Returns: The camera pose of the world origin in relation to the matched space's point cloud
    public func getCameraPose(queryPointCloud: PointCloud, location: CLLocation?, poseFinder: CameraPoseFinder) -> SpacePoseResult? {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Space")
        
        guard var spaces = try? moc.fetch(fetchRequest) as? [Space] else {
            return nil
        }
        
        if let loc = location {
            // sort the spaces by closest location if a location is provided
            spaces.sort(by: {$0.getLocation()?.distance(from: loc) ?? 1000.0 < $1.getLocation()?.distance(from: loc) ?? 1000.0})
        }
        
        for space in spaces {
            guard let referencePointCloud = space.getPointCloudData(),
                  let cameraPose = poseFinder.cameraPose(source: referencePointCloud, destination: queryPointCloud) else {
                continue
            }
            
            if cameraPose.confidence > 0.5 {
            return SpacePoseResult(space: space, pose: cameraPose.pose, confidence: cameraPose.confidence)
            }
            
            
        }
        return nil
        
    }
    
    
}


/// 3D camera pose of the device with 6 degrees of freedom in the matched space and the
/// system's confidence in the result's accuracy from 0 - 1.
struct SpacePoseResult {
    let space: Space
    let pose: simd_float4x4
    let confidence: Float
}


/// 3D camera pose with 6 degrees of freedom and the system's confidence in the result's accuracy from 0 to 1.
struct CameraPoseResult {
    let pose: simd_float4x4
    let confidence: Float
}


/// System capable of registering a point cloud within another with 6 degrees of freedom.
protocol CameraPoseFinder {
    
    /// In the context of localization, it is important to note that the source point cloud is the pre-existing scan because
    /// we want to find out where the pre-existing's scan's world origin maps to in the query cloud's space.
    /// - Parameters:
    ///   - source: point cloud to be mapped
    ///   - destination: cloud for the registration to be mapped to
    func cameraPose(source: PointCloud, destination: PointCloud) -> CameraPoseResult?
}
