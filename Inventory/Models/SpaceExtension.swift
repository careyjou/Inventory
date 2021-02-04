//
//  Space.swift
//  Inventory
//
//  Created by Vincent Spitale on 5/3/20.
//  Copyright © 2020 Vincent Spitale. All rights reserved.
//

import Foundation
import CoreData
import MapKit
import CoreData

extension Space {
    
    convenience init(moc: NSManagedObjectContext, name: String, pointCloud: Cloud, location: Location?) {
        self.init(context: moc)
        self.id = UUID()
        self.createdAt = Date()
        self.name = name
        self.location = location
        self.pointCloud = pointCloud
        
    }
    
    
    public func getCreatedAt() -> Date {
        return self.createdAt ?? Date()
    }
    
    public func getName() -> String? {
        return self.name
    }
    
    /// <#Description#>
    /// - Parameter newName: <#newName description#>
    public func setName(newName: String) -> Space {
    
        self.name = newName
        
        return self
    }
    
    public func setPointCloud(cloud: Cloud) -> Space {
        self.pointCloud = cloud
        return self
    }
    
    
 
    public func getImage(data: SpacePointCloudAppData) -> UIImage? {
            return nil
    }
    
    
    public func getPointCloud() -> Cloud? {
        return self.pointCloud
    }

    
    public func getAllItems() -> [Item] {
        let instances = self.getAllItemInstances()
        var itemSet = Set<Item>()
        
        for instance in instances {
            if let instanceItem = instance.item {
                itemSet.insert(instanceItem)
            }
        }
        
        return itemSet.map({$0})
        
    }
    
    public func getAllItemInstances() -> [ItemInstance] {
        var allItems = Set<ItemInstance>()
        
        if let positions = self.positions {
            for position in positions {
                if let pos = (position as? Position) {
                    let positionInstances = pos.getItemInstances()
                    for instance in positionInstances {
                    allItems.insert(instance)
                    }
                }
            }
        }
        
        return Array(allItems)
    }
    
    public func getMostRecentMovedDate() -> Date {
        var items = self.getAllItemInstances()
        
        items.sort(by: {$0.lastModified ?? Date() > $1.lastModified ?? Date()})
        
        return items.first?.getLastModified() ?? self.getCreatedAt()
        
    }
    
    public func getLocation() -> CLLocation? {
        if let loc = self.location {
            return loc.getLocation()
        }
        return nil
    }
    
    public func setLocation(location: Location) -> Space {
        self.location = location
        return self
    }
    
    
}




