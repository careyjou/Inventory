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
    convenience init(moc: NSManagedObjectContext, name: String) {
        self.init(context: moc)
        self.id = UUID()
        self.name = name
        self.createdAt = Date()
    }
    
    public func getName() -> String? {
        return self.name
    }
    
    /// <#Description#>
    /// - Parameter newName: <#newName description#>
    public func setName(newName: String) -> Item {
        self.name = newName
        
        return self
    }
    

    
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
    
        
        
    
    public func getQuantity() -> Int {
        var quantity = 0
        if let itemInstances = self.instances {
            for instance in itemInstances {
                quantity += (instance as? ItemInstance)?.getQuantity() ?? 0
            }
        }
        return quantity
    }
    
    public func getLastModified() -> Date {
        if (self.instances == nil) {
            return Date()
        }
        var lastModified: Date? = nil
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
    
    public func hasPosition() -> Bool {
        let instances = self.getInstances()
        let positions = instances.compactMap({$0.getPosition()})
        return !positions.isEmpty
    }
    
    
    

    
    
}
