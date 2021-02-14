//
//  ItemInstanceExtension.swift
//  Inventory
//
//  Created by Vincent Spitale on 7/19/20.
//  Copyright © 2020 Vincent Spitale. All rights reserved.
//

import SwiftUI
import CoreData
#if !targetEnvironment(macCatalyst)
import ARKit
#endif


extension ItemInstance {
    
    
    /// Create an identifiable ItemInstance from a context, its Item, Position linking it to a Space, and its quantity.
    /// - Parameters:
    ///   - moc: CoreData context
    ///   - item: Item that the instance inherits from
    ///   - position: where the item is located in a space
    ///   - quantity: the number of items of this type exist at this location
    convenience init(moc: NSManagedObjectContext, item: Item, position: Position?, quantity: Int) {
        self.init(context: moc)
        self.id = UUID()
        self.lastModified = Date()
        self.item = item
        self.position = position
        self.quantity = Int64(quantity)
    }
    
    
    /// Create an identifiable ItemInstance from a context, Item, and parent Instance,
    /// which recursively leads to a Position, that links to a Space.
    /// - Parameters:
    ///   - moc: CoreData context
    ///   - item: Item that the instance inherits from
    ///   - parentInstance: parent ItemInstance where this instance gets it's Position and Space
    ///   - quantity: the number of items of this type exist at this location
    convenience init(moc: NSManagedObjectContext, item: Item, parentInstance: ItemInstance, quantity: Int) {
        self.init(context: moc)
        self.id = UUID()
        self.lastModified = Date()
        self.item = item
        self.parent = parentInstance
        self.quantity = Int64(quantity)
    }
    
    
    /// Get the name of this item from the Item the instance inherits from.
    /// - Returns: Description of item
    public func getName() -> String? {
        return self.item?.name
    }
    
    
    /// Increment the quantity of this instance by 1.
    public func addOneQuantity() {
        self.quantity += 1
    }
    
    
    /// Decrement the quantity of this instance by 1 if the value will not become negative.
    public func subOneQuantity() {
        if !(self.quantity == 0) {
            self.quantity -= 1
        }
        
    }
    
    /// Change this instance's quantity to reflect a new number of items at this Position.
    /// - Parameter newQuantity: The updated number of items
    public func setQuantity(newQuantity: Int) -> ItemInstance {
        self.quantity = Int64(newQuantity)
        
        return self
    }
    
    
    
    /// Change the parent instance of this instance of this item while being sure
    /// not to introduce a cycle by having a child be a parent
    /// - Parameter instance: new parent
    /// - Returns: Reference to the modigied instance
    public func setParent(instance: ItemInstance) -> ItemInstance {
        guard (instance != self) else {
            return self
        }
        guard !self.getSubItems().contains(instance) else {
            return self
        }
        self.parent = instance
        self.position = nil
        return self
    }
    
    
    /// Get the chain of all items this instance is physically placed within.
    /// - Returns: The items that have a downward path to this instance
    public func getParents() -> [ItemInstance] {
        var parents = [ItemInstance]()
        if let myParent = self.parent {
            parents.append(contentsOf: myParent.getParents())
            parents.append(myParent)
        }
        return parents
    }
        
    
    /// Get when this instance was last moved.
    /// - Returns: The last time this item was given a new position.
    public func getLastModified() -> Date? {
        return self.lastModified
        
    }
    
    
    /// Gets how many items of this type are at this position.
    /// - Returns: Number of items of this type in real life
    public func getQuantity() -> Int {
        return Int(self.quantity)
    }
    
    
    
    /// If this instance has a parent instance, recursively find it's parent space.
    /// If there is not a parent, see if the instance's position has a space.
    /// - Returns: The Space this instance is located within
    public func getSpace() -> Space? {
        if let owner = self.parent {
            return owner.getSpace()
        }
        if let itemPosition = self.position {
            return itemPosition.getSpace()
        }
        return nil
    }
    
    
    /// Get all instances this instance contains within it.
    /// - Returns: All Items that are within this instance
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
    
    
    /// Direct inner items of this instance. Used for viewing the heirarchy of items.
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

    
    

    
    /// Modify this instance's position and remove it from its parent instance.
    /// - Parameter position: Where in a Space the instance is located
    public func setPosition(position: Position) -> ItemInstance {
        self.position = position
        self.parent = nil
        // the position of this instance has been modified
        self.lastModified = Date()
        
        return self
    }
    
    
    
    
    /// Get the exact position of this item from the Space's world origin.
    /// - Returns: x, y, z components (in meters)
    public func getTransform() -> simd_float3? {
        if let itemParent = self.parent {
            return itemParent.getTransform()
        }
        else {
            return self.position?.getTransform()
        }
    }
    
    
    
}
