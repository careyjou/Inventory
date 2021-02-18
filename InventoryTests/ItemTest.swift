//
//  ItemTest.swift
//  InventoryTests
//
//  Created by Vincent Spitale on 12/24/20.
//  Copyright © 2020 Vincent Spitale. All rights reserved.
//

import XCTest
import CoreData
@testable import Inventory

class ItemTest: XCTestCase {
    

    func testItemConstructor() {
        let item = Item(moc: TestCoreDataStack().persistentContainer.viewContext, name: "Hello")
        XCTAssert(item.name == "Hello")
        XCTAssert(item.createdAt != nil)
    }
    
    func testSetName() {
        let item = Item(moc: TestCoreDataStack().persistentContainer.viewContext, name: "Hello")
        XCTAssert(item.getName() == "Hello")
        _ = item.setName(newName: "World!")
        XCTAssert(item.getName() == "World!")
    }
    
    func testHasSpace() {
        let container = TestCoreDataStack().persistentContainer
        let item = Item(moc: container.viewContext, name: "Books")
        try? container.viewContext.save()
        XCTAssert(item.hasSpace() == false)
        let space = Space(context: container.viewContext)
        try? container.viewContext.save()
        let position = Position(moc: container.viewContext, position: simd_float3(x: 1, y: 1, z: 1), space: space)
        try? container.viewContext.save()
        
        // add item instance to position in a space
        let itemInstance = ItemInstance(moc: container.viewContext, item: item, position: position, quantity: 2)
        try? container.viewContext.save()
        XCTAssert(item.hasSpace() == true)
        
        // remove item instance from space
        _ = itemInstance.setPosition(position: Position(context: container.viewContext))
        try? container.viewContext.save()
        XCTAssert(item.hasSpace() == false)
    }
    
    func testGetQuantity() {
        let container = TestCoreDataStack().persistentContainer
        let item = Item(moc: container.viewContext, name: "Hello")
        try? container.viewContext.save()
        XCTAssert(item.getQuantity() == 0)
        let space = Space(context: container.viewContext)
        try? container.viewContext.save()
        let position = Position(moc: container.viewContext, position: simd_float3(x: 1, y: 1, z: 1), space: space)
        try? container.viewContext.save()
        
        // add item instance to position in a space
        let itemInstance = ItemInstance(moc: container.viewContext, item: item, position: position, quantity: 2)
        try? container.viewContext.save()
        XCTAssert(item.getQuantity() == 2)
        
        // add second item instance to another position in the same space
        let secondPosition = Position(moc: container.viewContext, position: simd_float3(x: 1, y: 2, z: 1), space: space)
        _ = ItemInstance(moc: container.viewContext, item: item, position: secondPosition, quantity: 3)
        XCTAssert(item.getQuantity() == 5)
        
        // delete first item instance
        container.viewContext.delete(itemInstance)
        try? container.viewContext.save()
        XCTAssert(item.getQuantity() == 3)
    }

    func testGetSpaces() {
        let container = TestCoreDataStack().persistentContainer
        let item = Item(moc: container.viewContext, name: "Books")
        try? container.viewContext.save()
        let space = Space(context: container.viewContext)
        try? container.viewContext.save()
        let position = Position(moc: container.viewContext, position: simd_float3(x: 1, y: 1, z: 1), space: space)
        try? container.viewContext.save()
        
        // add item instance to position in a space
        _ = ItemInstance(moc: container.viewContext, item: item, position: position, quantity: 2)
        try? container.viewContext.save()
        
        // add another item instance to a poistion in a different space
        let secondSpace = Space(context: container.viewContext)
        try? container.viewContext.save()
        let secondPosition = Position(moc: container.viewContext, position: simd_float3(x: 1, y: 2, z: 1), space: secondSpace)
        try? container.viewContext.save()
        _ = ItemInstance(moc: container.viewContext, item: item, position: secondPosition, quantity: 1)
        try? container.viewContext.save()
        
        let spaces = item.getSpaces()
        XCTAssert(spaces.count == 2)
        XCTAssert(spaces.contains(space))
        XCTAssert(spaces.contains(secondSpace))
        
    }
    
    func testGetInstances() {
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
        let secondItemInstance = ItemInstance(moc: container.viewContext, item: item, position: secondPosition, quantity: 1)
        try? container.viewContext.save()
        
        let instances = item.getInstances()
        
        XCTAssert(instances.count == 2)
        XCTAssert(instances.contains(itemInstance))
        XCTAssert(instances.contains(secondItemInstance))
    }
    
    func testHasPosition() {
        let container = TestCoreDataStack().persistentContainer
        let item = Item(moc: container.viewContext, name: "Books")
        try? container.viewContext.save()
        let space = Space(context: container.viewContext)
        try? container.viewContext.save()
        let position = Position(moc: container.viewContext, position: simd_float3(x: 1, y: 1, z: 1), space: space)
        try? container.viewContext.save()
        
        XCTAssert(item.hasPosition() == false)
        
        // add item instance to position in a space
        _ = ItemInstance(moc: container.viewContext, item: item, position: position, quantity: 2)
        try? container.viewContext.save()
        XCTAssert(item.hasPosition() == true)
        
    }
    
    
}

