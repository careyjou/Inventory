//
//  Findable.swift
//  Inventory
//
//  Created by Vincent Spitale on 1/16/21.
//  Copyright © 2021 Vincent Spitale. All rights reserved.
//

import Foundation


/// A type that can return a position from a query Space and describe itself.
protocol Findable {
    
    /// Gets an associated position from this type in the given space if it exists.
    /// - Parameter space: Query space
    func getTransform(space: Space) -> simd_float3?
    
    
    /// Gets  the descriptor for the findable type.
    func getName() -> String?
    
}

extension ItemInstance: Findable {
    
    func getTransform(space: Space) -> simd_float3? {
        if self.getSpace() == space {
            return self.getTransform()
        }
        else {
            return nil
        }
    }
    
    
}

extension Item: Findable {
    
    /// Get any item instance from this item that exists in the given
    /// space and return its position.
    func getTransform(space: Space) -> simd_float3? {
        let itemInstances = self.getInstances()
        
        for item in itemInstances {
            if item.getSpace() == space {
                return item.getTransform()
            }
        }
        
        return nil
    }
    
    
}
