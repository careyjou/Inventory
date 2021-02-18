//
//  ItemInstanceTest.swift
//  InventoryTests
//
//  Created by Vincent Spitale on 2/17/21.
//  Copyright © 2021 Vincent Spitale. All rights reserved.
//

import XCTest
import CoreData
@testable import Inventory

class ItemInstanceTest: XCTestCase {
    
    func testItemInstanceConstructor() {
        let container = TestCoreDataStack().persistentContainer
        let item = Item(moc: container.viewContext, name: "Bag")
        try? container.viewContext.save()
        let space = Space(context: container.viewContext)
        try? container.viewContext.save()
        let position = Position(moc: container.viewContext, position: simd_float3(x: 1, y: 1, z: 1), space: space)
        try? container.viewContext.save()
        
        // add item instance to position in a space
        let itemInstance = ItemInstance(moc: container.viewContext, item: item, position: position, quantity: 1)
        try? container.viewContext.save()
        XCTAssert(itemInstance.lastModified != nil)
        XCTAssert(itemInstance.item == item)
        XCTAssert(itemInstance.position == position)
        XCTAssert(itemInstance.quantity == 1)
        XCTAssert(itemInstance.parent == nil)
        
        // add another item instance to the first item instance
        let secondItem = Item(moc: container.viewContext, name: "Book")
        try? container.viewContext.save()
        let secondItemInstance = ItemInstance(moc: container.viewContext, item: secondItem, parentInstance: itemInstance, quantity: 3)
        try? container.viewContext.save()
        XCTAssert(secondItemInstance.lastModified != nil)
        XCTAssert(secondItemInstance.item == secondItem)
        XCTAssert(secondItemInstance.position == nil)
        XCTAssert(secondItemInstance.parent == itemInstance)
        XCTAssert(secondItemInstance.quantity == 3)
    }
    
    func testGetName() {
        let container = TestCoreDataStack().persistentContainer
        let item = Item(moc: container.viewContext, name: "Bag")
        try? container.viewContext.save()
        let space = Space(context: container.viewContext)
        try? container.viewContext.save()
        let position = Position(moc: container.viewContext, position: simd_float3(x: 1, y: 1, z: 1), space: space)
        try? container.viewContext.save()
        
        // add item instance to position in a space
        let itemInstance = ItemInstance(moc: container.viewContext, item: item, position: position, quantity: 1)
        try? container.viewContext.save()
        XCTAssert(itemInstance.getName() == "Bag")
        
        // add another item instance to the first item instance
        let secondItem = Item(moc: container.viewContext, name: "Book")
        try? container.viewContext.save()
        let secondItemInstance = ItemInstance(moc: container.viewContext, item: secondItem, parentInstance: itemInstance, quantity: 3)
        try? container.viewContext.save()
        XCTAssert(secondItemInstance.getName() == "Book")
    }
    
    func testAddOneQuantity() {
        let container = TestCoreDataStack().persistentContainer
        let item = Item(moc: container.viewContext, name: "Bag")
        try? container.viewContext.save()
        let space = Space(context: container.viewContext)
        try? container.viewContext.save()
        let position = Position(moc: container.viewContext, position: simd_float3(x: 1, y: 1, z: 1), space: space)
        try? container.viewContext.save()
        
        // add item instance to position in a space
        let itemInstance = ItemInstance(moc: container.viewContext, item: item, position: position, quantity: 1)
        try? container.viewContext.save()
        XCTAssert(itemInstance.getQuantity() == 1)
        itemInstance.addOneQuantity()
        XCTAssert(itemInstance.getQuantity() == 2)
        
    }
    
    func testSubOneQuantity() {
        let container = TestCoreDataStack().persistentContainer
        let item = Item(moc: container.viewContext, name: "Bag")
        try? container.viewContext.save()
        let space = Space(context: container.viewContext)
        try? container.viewContext.save()
        let position = Position(moc: container.viewContext, position: simd_float3(x: 1, y: 1, z: 1), space: space)
        try? container.viewContext.save()
        
        // add item instance to position in a space
        let itemInstance = ItemInstance(moc: container.viewContext, item: item, position: position, quantity: 1)
        try? container.viewContext.save()
        XCTAssert(itemInstance.getQuantity() == 1)
        itemInstance.subOneQuantity()
        XCTAssert(itemInstance.getQuantity() == 0)
        itemInstance.subOneQuantity()
        XCTAssert(itemInstance.getQuantity() == 0)
    }
    
    func testSetQuantity() {
        let container = TestCoreDataStack().persistentContainer
        let item = Item(moc: container.viewContext, name: "Bag")
        try? container.viewContext.save()
        let space = Space(context: container.viewContext)
        try? container.viewContext.save()
        let position = Position(moc: container.viewContext, position: simd_float3(x: 1, y: 1, z: 1), space: space)
        try? container.viewContext.save()
        
        // add item instance to position in a space
        let itemInstance = ItemInstance(moc: container.viewContext, item: item, position: position, quantity: 1)
        try? container.viewContext.save()
        XCTAssert(itemInstance.getQuantity() == 1)
        _ = itemInstance.setQuantity(newQuantity: 8)
        XCTAssert(itemInstance.getQuantity() == 8)
        _ = itemInstance.setQuantity(newQuantity: -5)
        XCTAssert(itemInstance.getQuantity() == 0)
        
    }
    
    func testSetParent() {
        let container = TestCoreDataStack().persistentContainer
        let item = Item(moc: container.viewContext, name: "Books")
        try? container.viewContext.save()
        let space = Space(context: container.viewContext)
        try? container.viewContext.save()
        let position = Position(moc: container.viewContext, position: simd_float3(x: 1, y: 1, z: 1), space: space)
        try? container.viewContext.save()
        
        // add item instance to position in a space
        let itemInstance = ItemInstance(moc: container.viewContext, item: item, position: position, quantity: 2)
        try? container.viewContext.save()
        
        // add another item instance to a position in a different space
        let secondSpace = Space(context: container.viewContext)
        try? container.viewContext.save()
        let secondPosition = Position(moc: container.viewContext, position: simd_float3(x: 1, y: 2, z: 1), space: secondSpace)
        try? container.viewContext.save()
        
        let secondItem = Item(moc: container.viewContext, name: "Bag")
        try? container.viewContext.save()
        let secondItemInstance = ItemInstance(moc: container.viewContext, item: secondItem, position: secondPosition, quantity: 1)
        try? container.viewContext.save()
        XCTAssert(itemInstance.parent == nil)
        XCTAssert(itemInstance.position == position)
        
        _ = itemInstance.setParent(instance: secondItemInstance)
        try? container.viewContext.save()
        
        XCTAssert(itemInstance.parent == secondItemInstance)
        XCTAssert(itemInstance.position == nil)
        
        // try to add self as parent
        _ = secondItemInstance.setParent(instance: secondItemInstance)
        XCTAssert(secondItemInstance.parent == nil)
        XCTAssert(secondItemInstance.position == secondPosition)
        
        
        // try to set child item instance as parent
        _ = secondItemInstance.setParent(instance: itemInstance)
        XCTAssert(secondItemInstance.parent == nil)
        XCTAssert(secondItemInstance.position == secondPosition)
        
    }
    
    func testGetParents() {
        let container = TestCoreDataStack().persistentContainer
        let item = Item(moc: container.viewContext, name: "Bag")
        try? container.viewContext.save()
        let space = Space(context: container.viewContext)
        try? container.viewContext.save()
        let position = Position(moc: container.viewContext, position: simd_float3(x: 1, y: 1, z: 1), space: space)
        try? container.viewContext.save()
        
        // add item instance to position in a space
        let itemInstance = ItemInstance(moc: container.viewContext, item: item, position: position, quantity: 1)
        try? container.viewContext.save()
        
        let secondItem = Item(moc: container.viewContext, name: "Small bag")
        try? container.viewContext.save()
        let secondItemInstance = ItemInstance(moc: container.viewContext, item: secondItem, parentInstance: itemInstance, quantity: 1)
        try? container.viewContext.save()
        
        let thirdItem = Item(moc: container.viewContext, name: "Books")
        try? container.viewContext.save()
        let thirdItemInstance = ItemInstance(moc: container.viewContext, item: thirdItem, parentInstance: secondItemInstance, quantity: 3)
        try? container.viewContext.save()
        
        let parents = thirdItemInstance.getParents()
        XCTAssert(parents.count == 2)
        XCTAssert(parents[0] == itemInstance)
        XCTAssert(parents[1] == secondItemInstance)
        
    }
    
    func testGetSpace() {
        let container = TestCoreDataStack().persistentContainer
        let item = Item(moc: container.viewContext, name: "Bag")
        try? container.viewContext.save()
        let space = Space(context: container.viewContext)
        try? container.viewContext.save()
        let position = Position(moc: container.viewContext, position: simd_float3(x: 1, y: 1, z: 1), space: space)
        try? container.viewContext.save()
        
        // add item instance to position in a space
        let itemInstance = ItemInstance(moc: container.viewContext, item: item, position: position, quantity: 1)
        try? container.viewContext.save()
        
        let secondItem = Item(moc: container.viewContext, name: "Small bag")
        try? container.viewContext.save()
        let secondItemInstance = ItemInstance(moc: container.viewContext, item: secondItem, parentInstance: itemInstance, quantity: 1)
        try? container.viewContext.save()
        
        let thirdItem = Item(moc: container.viewContext, name: "Books")
        try? container.viewContext.save()
        let thirdItemInstance = ItemInstance(moc: container.viewContext, item: thirdItem, parentInstance: secondItemInstance, quantity: 3)
        try? container.viewContext.save()
        
        XCTAssert(itemInstance.getSpace() == space)
        XCTAssert(secondItemInstance.getSpace() == space)
        XCTAssert(thirdItemInstance.getSpace() == space)
        
        let newPosition = Position(context: container.viewContext)
        try? container.viewContext.save()
        _ = itemInstance.setPosition(position: newPosition)
        try? container.viewContext.save()
        
        XCTAssert(itemInstance.getSpace() == nil)
        XCTAssert(secondItemInstance.getSpace() == nil)
        XCTAssert(thirdItemInstance.getSpace() == nil)
        
    }
    
    func testGetSubItems() {
        let container = TestCoreDataStack().persistentContainer
        let item = Item(moc: container.viewContext, name: "Bag")
        try? container.viewContext.save()
        let space = Space(context: container.viewContext)
        try? container.viewContext.save()
        let position = Position(moc: container.viewContext, position: simd_float3(x: 1, y: 1, z: 1), space: space)
        try? container.viewContext.save()
        
        // add item instance to position in a space
        let itemInstance = ItemInstance(moc: container.viewContext, item: item, position: position, quantity: 1)
        try? container.viewContext.save()
        
        let secondItem = Item(moc: container.viewContext, name: "Small bag")
        try? container.viewContext.save()
        let secondItemInstance = ItemInstance(moc: container.viewContext, item: secondItem, parentInstance: itemInstance, quantity: 1)
        try? container.viewContext.save()
        
        let thirdItem = Item(moc: container.viewContext, name: "Books")
        try? container.viewContext.save()
        let thirdItemInstance = ItemInstance(moc: container.viewContext, item: thirdItem, parentInstance: secondItemInstance, quantity: 3)
        try? container.viewContext.save()
        
        let itemInstanceSubItems = itemInstance.getSubItems()
        XCTAssert(itemInstanceSubItems.count == 2)
        XCTAssert(itemInstanceSubItems.contains(secondItemInstance))
        XCTAssert(itemInstanceSubItems.contains(thirdItemInstance))
        
        let secondItemInstanceSubItems = secondItemInstance.getSubItems()
        XCTAssert(secondItemInstanceSubItems.count == 1)
        XCTAssert(secondItemInstanceSubItems.contains(thirdItemInstance))
        
        let thirdItemInstanceSubItems = thirdItemInstance.getSubItems()
        XCTAssert(thirdItemInstanceSubItems.count == 0)
    }
    
    func testGetDirectSubItems() {
        let container = TestCoreDataStack().persistentContainer
        let item = Item(moc: container.viewContext, name: "Bag")
        try? container.viewContext.save()
        let space = Space(context: container.viewContext)
        try? container.viewContext.save()
        let position = Position(moc: container.viewContext, position: simd_float3(x: 1, y: 1, z: 1), space: space)
        try? container.viewContext.save()
        
        // add item instance to position in a space
        let itemInstance = ItemInstance(moc: container.viewContext, item: item, position: position, quantity: 1)
        try? container.viewContext.save()
        
        let secondItem = Item(moc: container.viewContext, name: "Small bag")
        try? container.viewContext.save()
        let secondItemInstance = ItemInstance(moc: container.viewContext, item: secondItem, parentInstance: itemInstance, quantity: 1)
        try? container.viewContext.save()
        
        let thirdItem = Item(moc: container.viewContext, name: "Books")
        try? container.viewContext.save()
        let thirdItemInstance = ItemInstance(moc: container.viewContext, item: thirdItem, parentInstance: secondItemInstance, quantity: 3)
        try? container.viewContext.save()
        
        if let itemInstanceSubItems = itemInstance.directSubItems {
        XCTAssert(itemInstanceSubItems.count == 1)
        XCTAssert(itemInstanceSubItems.contains(secondItemInstance))
        }
        
        if let secondItemInstanceSubItems = secondItemInstance.directSubItems {
        XCTAssert(secondItemInstanceSubItems.count == 1)
        XCTAssert(secondItemInstanceSubItems.contains(thirdItemInstance))
        }
        
        if let thirdItemInstanceSubItems = thirdItemInstance.directSubItems {
        XCTAssert(thirdItemInstanceSubItems.count == 0)
        }
    }
    
    func testSetPosition() {
        let container = TestCoreDataStack().persistentContainer
        let item = Item(moc: container.viewContext, name: "Bag")
        try? container.viewContext.save()
        let space = Space(context: container.viewContext)
        try? container.viewContext.save()
        let position = Position(moc: container.viewContext, position: simd_float3(x: 1, y: 1, z: 1), space: space)
        try? container.viewContext.save()
        
        // add item instance to position in a space
        let itemInstance = ItemInstance(moc: container.viewContext, item: item, position: position, quantity: 1)
        try? container.viewContext.save()
        
        let date = itemInstance.getLastModified()
        
        let secondPosition = Position(context: container.viewContext)
        try? container.viewContext.save()

        XCTAssert(itemInstance.position == position)
        
        _ = itemInstance.setPosition(position: secondPosition)
        try? container.viewContext.save()
        
        XCTAssert(itemInstance.position == secondPosition)
        XCTAssert(itemInstance.getLastModified() != date)
        
        let secondItem = Item(moc: container.viewContext, name: "Small bag")
        try? container.viewContext.save()
        let secondItemInstance = ItemInstance(moc: container.viewContext, item: secondItem, parentInstance: itemInstance, quantity: 1)
        try? container.viewContext.save()
        
        XCTAssert(secondItemInstance.position == nil)
        XCTAssert(secondItemInstance.parent == itemInstance)
        
        _ = secondItemInstance.setPosition(position: position)
        try? container.viewContext.save()
        
        XCTAssert(secondItemInstance.position == position)
        XCTAssert(secondItemInstance.parent == nil)
    }
    
    func testGetTransform() {
        let container = TestCoreDataStack().persistentContainer
        let item = Item(moc: container.viewContext, name: "Bag")
        try? container.viewContext.save()
        let space = Space(context: container.viewContext)
        try? container.viewContext.save()
        let position = Position(moc: container.viewContext, position: simd_float3(x: 1, y: 1, z: 1), space: space)
        try? container.viewContext.save()
        
        // add item instance to position in a space
        let itemInstance = ItemInstance(moc: container.viewContext, item: item, position: position, quantity: 1)
        try? container.viewContext.save()
        
        let secondItem = Item(moc: container.viewContext, name: "Small bag")
        try? container.viewContext.save()
        let secondItemInstance = ItemInstance(moc: container.viewContext, item: secondItem, parentInstance: itemInstance, quantity: 1)
        try? container.viewContext.save()
        
        XCTAssert(itemInstance.getTransform() == simd_float3(x: 1, y: 1, z: 1))
        XCTAssert(secondItemInstance.getTransform() == simd_float3(x: 1, y: 1, z: 1))
        
        let secondPosition = Position(moc: container.viewContext, position: simd_float3(x: 1, y: 2, z: 1), space: space)
        try? container.viewContext.save()
        
        _ = secondItemInstance.setPosition(position: secondPosition)
        XCTAssert(secondItemInstance.getTransform() == simd_float3(x: 1, y: 2, z: 1))
        
        
    }
    
    
    
    
}
