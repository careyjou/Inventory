//
//  Item.swift
//  Inventory
//
//  Created by Vincent Spitale on 5/3/20.
//  Copyright © 2020 Vincent Spitale. All rights reserved.
//

import SwiftUI
import CoreData
#if !targetEnvironment(macCatalyst)
import ARKit
#endif



extension Item {
    
    /// Create an identifiable Item with a context and description of the item.
    /// - Parameters:
    ///   - moc: CoreData context
    ///   - name: brief item description
    convenience init(moc: NSManagedObjectContext, name: String) {
        self.init(context: moc)
        self.id = UUID()
        self.name = name
        self.createdAt = Date()
    }
    
    
    /// Get the description of this Item.
    /// - Returns: Item descriptor
    public func getName() -> String? {
        return self.name
    }
    
    /// Modify this Item to have a new description of the item
    /// - Parameter newName: New item descriptor
    public func setName(newName: String) -> Item {
        self.name = newName
        
        return self
    }
    

    
    /// Is this item placed within any spaces?
    /// - Returns: true if there is an item instance in a space, false otherwise
    public func hasSpace() -> Bool {
        if let itemInstances = self.instances {
            for instance in itemInstances {
                if ((instance as? ItemInstance)?.getSpace() != nil) {
                    return true
                }
            }
        }
            return false
    }
    
        
        
    
    /// Get the total combined quantity of all instances of this item.
    /// - Returns: Total quantity
    public func getQuantity() -> Int {
        var quantity = 0
        if let itemInstances = self.instances {
            for instance in itemInstances {
                quantity += (instance as? ItemInstance)?.getQuantity() ?? 0
            }
        }
        return quantity
    }
    
    /// When was any of this items last modified. Used for sorting items.
    /// - Returns: The most recent time when any instance of this item was moved
    public func getLastModified() -> Date {
        var lastModified: Date? = self.createdAt
        if let itemInstances = self.instances {
            var dates = itemInstances.compactMap({($0 as? ItemInstance)?.getLastModified()})
            dates.sort()
            lastModified = dates.last
        }
        if let date = lastModified {
            return date
        }
        else {
            return Date()
        }
    }
    
    /// Get all of the spaces where instances of this item can be found within.
    /// - Returns: All spaces that contain instances of this item
    public func getSpaces() -> [Space] {
        var spaces: [Space] = []
        
        if let itemInstances = self.instances {
            for instance in itemInstances {
                if let space = (instance as? ItemInstance)?.getSpace() {
                    spaces.append(space)
                }
            }
        }
        
        return spaces
        
    }
    
    /// Get all instances of this item
    /// - Returns: all instances representing physical positions of this item
    public func getInstances() -> [ItemInstance] {
        var allInstances = [ItemInstance]()
        if let itemInstances = self.instances {
            for instance in itemInstances {
                if let item = (instance as? ItemInstance) {
                    allInstances.append(item)
                }
            }
        }
        return allInstances
    }
    
    
    /// Do any of this item's instances have a position in a space?
    /// - Returns: True if any item has an z, y, z position, false otherwise
    public func hasPosition() -> Bool {
        let instances = self.getInstances()
        let positions = instances.compactMap({$0.getTransform()})
        return !positions.isEmpty
    }
    
    
    

    
    
}
