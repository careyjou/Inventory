//
//  CloudExtension.swift
//  Inventory
//
//  Created by Vincent Spitale on 12/21/20.
//  Copyright © 2020 Vincent Spitale. All rights reserved.
//

import Foundation
import CoreData

extension Cloud {
    
    
    /// Create an identifiable Cloud with the managed context.
    /// - Parameter moc: Core Data context
    convenience init(moc: NSManagedObjectContext) {
        self.init(context: moc)
        self.id = UUID()
        
    }
    
    
    /// Set the Cloud's pointcloud to a JSON encoded PointCloud
    /// - Parameter pointCloud: JSON encoded PointCloud
    public func setPointCloud(pointCloud: Data?) {
        self.pointCloud = pointCloud
    }
    
}
