//
//  PositionExtension.swift
//  Inventory
//
//  Created by Vincent Spitale on 12/20/20.
//  Copyright © 2020 Vincent Spitale. All rights reserved.
//

import Foundation

extension Position {
    
    public func setID() -> Position {
        self.id = UUID()
        return self
    }
    
    public func getSpace() -> Space? {
        return self.space
    }
    
    public func getItemInstances() -> [ItemInstance] {
        var allInstances = [ItemInstance]()
        if let instances = self.items {
            for instance in instances {
                if let item = (instance as? ItemInstance) {
                    allInstances.append(item)
                    allInstances.append(contentsOf: item.getSubItems())
                }
            }
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
