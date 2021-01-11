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
    
    init?(appData: SpacePointCloudAppData) {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
              return nil
          }
        
        self.data = appData
        self.moc = appDelegate.persistentContainer.viewContext
    }
    
    
    /// <#Description#>
    /// - Parameters:
    ///   - queryPointCloud: <#queryPointCloud description#>
    ///   - location: <#location description#>
    /// - Returns: <#description#>
    public func getCameraPose(queryPointCloud: PointCloud, location: CLLocation?) -> CameraPoseResult? {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Space")
        
        guard var spaces = try? moc.fetch(fetchRequest) as? [Space] else {
            return nil
        }
        
        if let loc = location {
        spaces.sort(by: {$0.getLocation()?.distance(from: loc) ?? 1000.0 < $1.getLocation()?.distance(from: loc) ?? 1000.0})
        }
        
        for space in spaces {
            //TODO
            guard let referenceCloud = data.getPointCloud(space: space) else {
                continue
            }
            
            
            let cameraPose = CameraPoseFinder_Wrapper()
            
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
        
        let scaleFactor: Float = 0.99 / maxDimension
        let scaledQueryPointCloud = self.scaleCloud(cloud: queryPointCloud, scaleFactor: scaleFactor)
        let scaledReferencePointCloud = self.scaleCloud(cloud: referencePointCloud, scaleFactor: scaleFactor)
        
        return ScaledPointCloudsResult(scaledQueryPointCloud: scaledQueryPointCloud, scaledReferencePointCloud: scaledReferencePointCloud, scaleFactor: scaleFactor)
    }

    private func scaleCloud(cloud: PointCloud, scaleFactor: Float) -> [SCNVector3] {
        let points = cloud.getPointCloud()
        return points.map({SCNVector3(x: $0.x * scaleFactor, y: $0.y * scaleFactor, z: $0.z * scaleFactor)})
    }
    
}


struct ScaledPointCloudsResult {
    let scaledQueryPointCloud: [SCNVector3]
    let scaledReferencePointCloud: [SCNVector3]
    let scaleFactor: Float
}


struct CameraPoseResult {
    let space: Space
    let pose: simd_float4x4
    let confidence: Float
}
