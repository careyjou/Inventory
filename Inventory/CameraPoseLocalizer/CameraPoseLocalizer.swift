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
    public func getCameraPose(queryPointCloud: PointCloud, location: CLLocation?) -> ((Space, simd_float4x4), Float)? {
        
        
    }
    
}
