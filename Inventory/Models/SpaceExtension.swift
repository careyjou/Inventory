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
    
    /// Create an identifiable Space with context, description of the area,
    /// corresponding point cloud capture, and optional location for faster localization.
    /// - Parameters:
    ///   - moc: CoreData context
    ///   - name: brief space description
    ///   - pointCloud: capture used for localization
    ///   - location: precise geographical position which speeds up localization
    convenience init(moc: NSManagedObjectContext, name: String, pointCloud: Cloud, location: Location?) {
        self.init(context: moc)
        self.id = UUID()
        self.createdAt = Date()
        self.name = name
        self.location = location
        self.pointCloud = pointCloud
        
    }
    
    
    /// Get the description of this space
    /// - Returns: brief space descripter
    public func getName() -> String? {
        return self.name
    }
    
    
    /// Modify the description of this space
    /// - Parameter newName: The descriptor the space will now have
    /// - Returns: Reference to this modified Space
    public func setName(newName: String) -> Space {
    
        self.name = newName
        
        return self
    }
    
            
    
    /// Get a reference to the capture data from this space
    /// - Returns: Point cloud data reference
    public func getPointCloud() -> Cloud? {
        return self.pointCloud
    }

    
    /// Get all types of items that are within this space
    /// - Returns: An unsorted sequence of all items accessible in this space
    public func getAllItems() -> [Item] {
        let instances = self.getAllItemInstances()
        var itemSet = Set<Item>()
        
        for instance in instances {
            if let instanceItem = instance.item {
                itemSet.insert(instanceItem)
            }
        }
        
        return Array(itemSet)
        
    }
    
    /// Get all of the item instances within this space
    /// - Returns: All ItemInstances with an upward path to a position in this space
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
    
    
    /// Returns when the last item instance was moved within the space. This date is used to
    /// sort the space by relevance.
    /// - Returns: When the last item instance's position was changed
    public func getMostRecentMovedDate() -> Date {
        var items = self.getAllItemInstances()
        
        items.sort(by: {$0.lastModified ?? Date() > $1.lastModified ?? Date()})
        
        return items.first?.getLastModified() ?? (self.createdAt ?? Date())
        
    }
    
    
    /// Return the geographical location of this space if it exists.
    /// - Returns: optional reference to georgraphical coordinates
    public func getLocation() -> CLLocation? {
        if let loc = self.location {
            return loc.getLocation()
        }
        return nil
    }
    
    
    /// Update the geographical position of this space to improve localization speed.
    /// - Parameter location: New reference to geographical coordinates
    public func setLocation(location: Location) {
        self.location = location
    }
    
    
}




