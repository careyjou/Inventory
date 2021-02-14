//
//  PositionExtension.swift
//  Inventory
//
//  Created by Vincent Spitale on 12/20/20.
//  Copyright © 2020 Vincent Spitale. All rights reserved.
//

import Foundation
import CoreData

extension Position {
    
    
    /// Create an identifiable position with the context, position (in meters), and space.
    /// - Parameters:
    ///   - moc: Core Data context
    ///   - position: x,y,z position (in meters)
    ///   - space: Space the position is within
    convenience init(moc: NSManagedObjectContext, position: simd_float3, space: Space) {
        self.init(context: moc)
        self.id = UUID()
        self.x = position.x
        self.y = position.y
        self.z = position.z
        self.space = space
    }
    
    
    /// Returns the space this position is within.
    /// - Returns: parent Space
    public func getSpace() -> Space? {
        return self.space
    }
    
    
    /// <#Description#>
    /// - Returns: <#description#>
    public func getItemInstances() -> [ItemInstance] {
        var allInstances = [ItemInstance]()
        if let instance = self.item {
                    allInstances.append(instance)
                    allInstances.append(contentsOf: instance.getSubItems())
        }
        return allInstances
    }
    
    public func setPosition(position: simd_float3) -> Position {
        self.x = position.x
        self.y = position.y
        self.z = position.z
        
        return self
    }
    
    public func setSpace(space: Space) -> Position {
        self.space = space
        
        return self
    }
    
    public func getTransform() -> simd_float3 {
        return simd_float3(x: self.x, y: self.y, z: self.z)
    }
    
}
