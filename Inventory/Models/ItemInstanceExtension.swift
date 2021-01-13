//
//  ItemInstanceExtension.swift
//  Inventory
//
//  Created by Vincent Spitale on 7/19/20.
//  Copyright © 2020 Vincent Spitale. All rights reserved.
//

import SwiftUI
import Combine
#if !targetEnvironment(macCatalyst)
import ARKit
#endif


extension ItemInstance {
    
    public func setID() -> ItemInstance {
        self.id = UUID()
        return self
    }
    
    public func getName() -> String? {
        return self.item?.name
    }
    
    
    /// <#Description#>
    public func addOneQuantity() {
        self.quantity += 1
    }
    
    
    /// <#Description#>
    public func subOneQuantity() {
        if !(self.quantity == 0) {
            self.quantity -= 1
        }
        
    }
    
    /// <#Description#>
    /// - Parameter newQuantity: <#newQuantity description#>
    public func setQuantity(newQuantity: Int) -> ItemInstance {
        self.quantity = Int64(newQuantity)
        
        return self
    }
    
    /// <#Description#>
    public func setDate() -> ItemInstance {
        
        self.lastModified = Date()
        return self
        
    }
    
    public func setParent(instance: ItemInstance) -> ItemInstance {
        guard !self.getSubItems().contains(instance) else {
            return self
        }
        self.parent = instance
        return self
    }
    
    public func getParents() -> [ItemInstance] {
        var parents = [ItemInstance]()
        if let myParent = self.parent {
            parents.append(contentsOf: myParent.getParents())
            parents.append(myParent)
        }
        return parents
    }
    
    
    private func setLastUpdated() -> ItemInstance {
        
        self.lastModified = Date()
        
        return self
        
    }
    
    
    
    public func getLastModified() -> Date {
        return self.lastModified ?? Date()
        
    }
    
    public func getQuantity() -> Int {
        return Int(self.quantity)
    }
    
    
    
    public func getSpace() -> Space? {
        if let owner = self.parent {
            return owner.getSpace()
        }
        if let itemPosition = self.position {
            return itemPosition.getSpace()
        }
        return nil
    }
    
    public func getSubItems() -> [ItemInstance] {
        var subItems = [ItemInstance]()
        if let instanceChildren = self.children {
        for instance in instanceChildren {
            if let subItem = (instance as? ItemInstance) {
                subItems.append(subItem)
                subItems.append(contentsOf: subItem.getSubItems())
            }
        }
        }
        return subItems
    }
    
    var directSubItems: [ItemInstance]? {
        var subItems = [ItemInstance]()
        if let instanceChildren = self.children {
        for instance in instanceChildren {
            if let subItem = (instance as? ItemInstance) {
                subItems.append(subItem)
            }
        }
        }
        return subItems
    }

    
    
    

    
    /// <#Description#>
    /// - Parameter vector: <#vector description#>
    public func setPosition(position: Position) -> ItemInstance {
        self.position = position
        self.lastModified = Date()
        
        return self
    }
    
    
    
    /// <#Description#>
    /// - Returns: <#description#>
    public func getPosition() -> Position? {
        return self.position
    }
    
    
    
}
