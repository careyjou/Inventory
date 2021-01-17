//
//  Findable.swift
//  Inventory
//
//  Created by Vincent Spitale on 1/16/21.
//  Copyright © 2021 Vincent Spitale. All rights reserved.
//

import Foundation

protocol Findable {
    
    func getTransform(space: Space) -> simd_float3?
    
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
