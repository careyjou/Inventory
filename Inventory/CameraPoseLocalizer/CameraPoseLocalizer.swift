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
    public func getCameraPose(queryPointCloud: PointCloud, location: CLLocation?) -> CameraPoseResult? {
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
            
            let scaledClouds = self.scalePointClouds(queryPointCloud: queryPointCloud, referencePointCloud: referencePointCloud)
            
            let scaledQueryCloud = scaledClouds.scaledQueryPointCloud
            let scaledReferenceCloud = scaledClouds.scaledReferencePointCloud
            
            let unsafeQueryCloud = UnsafeMutableBufferPointer<POINT3D>.allocate(capacity: scaledQueryCloud.count)
                
            _ = unsafeQueryCloud.initialize(from: scaledQueryCloud)
            
            let unsafeReferenceCloud = UnsafeMutableBufferPointer<POINT3D>.allocate(capacity: scaledReferenceCloud.count)
            
            
            _ = unsafeReferenceCloud.initialize(from: scaledReferenceCloud)
            
           
            guard let unsafeQueryPointer = unsafeQueryCloud.baseAddress else {
                continue
            }
            
            guard let unsafeReferencePointer = unsafeReferenceCloud.baseAddress else {
                continue
            }
            
            
            let cameraPose = CameraPoseFinder_Wrapper().getCameraPose(unsafeQueryPointer, queryCloudSize: Int32(scaledClouds.scaledQueryPointCloud.count), referenceCloud: unsafeReferencePointer, referenceCloudSize: Int32(scaledClouds.scaledReferencePointCloud.count))
            
            // initially unscaled
            var pose = simd_float4x4(cameraPose.matrix)
            // undo scaling
            pose.columns.3.x = pose.columns.3.x / scaledClouds.scaleFactor
            pose.columns.3.y = pose.columns.3.y / scaledClouds.scaleFactor
            pose.columns.3.z = pose.columns.3.z / scaledClouds.scaleFactor
            
            if cameraPose.error < 0.2 {
                return CameraPoseResult(space: space, pose: pose, confidence: max((1 - cameraPose.error), 0))
            }
            
        }
        return nil
        
    }
    
    
    /// The c++ implementation of the go icp algorithm requires that both clouds fit within 1 unit cubed.
    /// Therefore, the point clouds need to be scaled down by the same scale factor for them to be aligned.
    /// This is done by finding the maximum dimensions and scaling down by the largest outlier.
    /// - Parameters:
    ///   - queryPointCloud: reference we are attempting to localize
    ///   - referencePointCloud: original scan of the space
    /// - Returns: The query point cloud appropriately scaled, the reference point cloud appropriately scaled (both losing color information), and the scale factor
    private func scalePointClouds(queryPointCloud: PointCloud, referencePointCloud: PointCloud) -> ScaledPointCloudsResult {
        var maxDimension: Float = 0.001
        for p in queryPointCloud.getPointCloud() {
            maxDimension = max(maxDimension, abs(p.x),abs(p.y),abs(p.z))
        }
        
        for p in referencePointCloud.getPointCloud() {
            maxDimension = max(maxDimension, abs(p.x),abs(p.y),abs(p.z))
        }
        
        let scaleFactor: Float = 0.499 / maxDimension
        let scaledQueryPointCloud = self.scaleCloud(cloud: queryPointCloud, scaleFactor: scaleFactor)
        let scaledReferencePointCloud = self.scaleCloud(cloud: referencePointCloud, scaleFactor: scaleFactor)
        
        return ScaledPointCloudsResult(scaledQueryPointCloud: scaledQueryPointCloud, scaledReferencePointCloud: scaledReferencePointCloud, scaleFactor: scaleFactor)
    }

    private func scaleCloud(cloud: PointCloud, scaleFactor: Float) -> [POINT3D] {
        let points = cloud.getPointCloud()
        return points.map({POINT3D(x: $0.x * scaleFactor, y: $0.y * scaleFactor, z: $0.z * scaleFactor)})
    }
    
}


struct ScaledPointCloudsResult {
    let scaledQueryPointCloud: [POINT3D]
    let scaledReferencePointCloud: [POINT3D]
    let scaleFactor: Float
}


struct CameraPoseResult {
    let space: Space
    let pose: simd_float4x4
    let confidence: Float
}
