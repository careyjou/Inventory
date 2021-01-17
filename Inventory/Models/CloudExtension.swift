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
    
    convenience init(moc: NSManagedObjectContext) {
        self.init(context: moc)
        self.id = UUID()
        
    }
    
    
    public func setPointCloud(pointCloud: Data?) {
        self.pointCloud = pointCloud
    }
    
}
