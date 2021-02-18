//
//  SpaceTest.swift
//  InventoryTests
//
//  Created by Vincent Spitale on 2/18/21.
//  Copyright © 2021 Vincent Spitale. All rights reserved.
//

import XCTest
import CoreData
@testable import Inventory

class SpaceTest: XCTestCase {
    
    func testConstructor() throws {
        let container = TestCoreDataStack().persistentContainer
        
        let bundle = Bundle(for: type(of: self))
        guard let couch = bundle.url(forResource: "couch-1", withExtension: "ply"),
            let couchPoints = Utils.pointsFromPLY(url: couch) else {
            throw ParsingError.couldNotLoad
        }
        
        let encoder = JSONEncoder()
        
        let data = try? encoder.encode(couchPoints)
        
        let cloud = Cloud(moc: container.viewContext)
        cloud.setPointCloud(pointCloud: data)
        
        try? container.viewContext.save()
        
        let space = Space(moc: container.viewContext, name: "Hello", pointCloud: cloud, location: nil)
        
        try? container.viewContext.save()
        
        let secondCloud = Cloud(moc: container.viewContext)
        cloud.setPointCloud(pointCloud: data)
        try? container.viewContext.save()
        
        let location = Location(moc: container.viewContext, location: CLLocation(latitude: 10, longitude: 10))
        
        try? container.viewContext.save()
        
        let secondSpace = Space(moc: container.viewContext, name: "World!", pointCloud: secondCloud, location: location)
        
        XCTAssert(space.id != nil)
        XCTAssert(space.createdAt != nil)
        XCTAssert(space.name == "Hello")
        XCTAssert(space.location == nil)
        XCTAssert(space.pointCloud == cloud)
        
        XCTAssert(secondSpace.id != nil)
        XCTAssert(secondSpace.createdAt != nil)
        XCTAssert(secondSpace.name == "World!")
        XCTAssert(secondSpace.location == location)
        XCTAssert(secondSpace.pointCloud == secondCloud)
        
        
    }
    
    func testGetName() throws {
        let container = TestCoreDataStack().persistentContainer
        
        let bundle = Bundle(for: type(of: self))
        guard let couch = bundle.url(forResource: "couch-1", withExtension: "ply"),
            let couchPoints = Utils.pointsFromPLY(url: couch) else {
            throw ParsingError.couldNotLoad
        }
        
        let encoder = JSONEncoder()
        
        let data = try? encoder.encode(couchPoints)
        
        let cloud = Cloud(moc: container.viewContext)
        cloud.setPointCloud(pointCloud: data)
        
        try? container.viewContext.save()
        
        let space = Space(moc: container.viewContext, name: "Hello", pointCloud: cloud, location: nil)
        
        try? container.viewContext.save()
        
        XCTAssert(space.getName() == "Hello")
    }
    
    func testSetName() throws {
        let container = TestCoreDataStack().persistentContainer
        
        let bundle = Bundle(for: type(of: self))
        guard let couch = bundle.url(forResource: "couch-1", withExtension: "ply"),
            let couchPoints = Utils.pointsFromPLY(url: couch) else {
            throw ParsingError.couldNotLoad
        }
        
        let encoder = JSONEncoder()
        
        let data = try? encoder.encode(couchPoints)
        
        let cloud = Cloud(moc: container.viewContext)
        cloud.setPointCloud(pointCloud: data)
        
        try? container.viewContext.save()
        
        let space = Space(moc: container.viewContext, name: "Hello", pointCloud: cloud, location: nil)
        
        try? container.viewContext.save()
        
        _ = space.setName(newName: "World!")
        
        try? container.viewContext.save()
        
        XCTAssert(space.getName() == "World!")
    }
    
    func testGetPointCloud() throws {
        let container = TestCoreDataStack().persistentContainer
        
        let bundle = Bundle(for: type(of: self))
        guard let couch = bundle.url(forResource: "couch-1", withExtension: "ply"),
            let couchPoints = Utils.pointsFromPLY(url: couch) else {
            throw ParsingError.couldNotLoad
        }
        
        let encoder = JSONEncoder()
        
        let data = try? encoder.encode(couchPoints)
        
        let cloud = Cloud(moc: container.viewContext)
        cloud.setPointCloud(pointCloud: data)
        
        try? container.viewContext.save()
        
        let space = Space(moc: container.viewContext, name: "Hello", pointCloud: cloud, location: nil)
        
        try? container.viewContext.save()
        
        XCTAssert(space.getPointCloud() == cloud)
    }
    
    func testGetAllItems() throws {
        let container = TestCoreDataStack().persistentContainer
        
        let bundle = Bundle(for: type(of: self))
        guard let couch = bundle.url(forResource: "couch-1", withExtension: "ply"),
            let couchPoints = Utils.pointsFromPLY(url: couch) else {
            throw ParsingError.couldNotLoad
        }
        
        let encoder = JSONEncoder()
        
        let data = try? encoder.encode(couchPoints)
        
        let cloud = Cloud(moc: container.viewContext)
        cloud.setPointCloud(pointCloud: data)
        
        try? container.viewContext.save()
        
        let space = Space(moc: container.viewContext, name: "Hello", pointCloud: cloud, location: nil)
        
        try? container.viewContext.save()
        
        var spaceItems = space.getAllItems()
        
        XCTAssert(spaceItems.count == 0)
        
        let item = Item(moc: container.viewContext, name: "Bag")
        try? container.viewContext.save()
        
        let position = Position(moc: container.viewContext, position: simd_float3(x: 1, y: 1, z: 1), space: space)
        try? container.viewContext.save()
        
        // add item instance to position in the space
        let itemInstance = ItemInstance(moc: container.viewContext, item: item, position: position, quantity: 1)
        try? container.viewContext.save()
        
        // add another item instance within the first Item Instance
        let secondItem = Item(moc: container.viewContext, name: "Books")
        try? container.viewContext.save()
        _ = ItemInstance(moc: container.viewContext, item: secondItem, parentInstance: itemInstance, quantity: 2)
        try? container.viewContext.save()
        
        spaceItems = space.getAllItems()
        
        XCTAssert(spaceItems.count == 2)
        XCTAssert(spaceItems.contains(item))
        XCTAssert(spaceItems.contains(secondItem))
        
        let secondPosition = Position(moc: container.viewContext, position: simd_float3(x: 1, y: 2, z: 3), space: space)
        
        try? container.viewContext.save()
        
        // add another item instance with the same item, output count should remain the same
        _ = ItemInstance(moc: container.viewContext, item: item, position: secondPosition, quantity: 2)
        
        try? container.viewContext.save()
        spaceItems = space.getAllItems()
        
        XCTAssert(spaceItems.count == 2)
        XCTAssert(spaceItems.contains(item))
        XCTAssert(spaceItems.contains(secondItem))
        
    }
    
    func testGetAllItemInstances() throws {
        let container = TestCoreDataStack().persistentContainer
        
        let bundle = Bundle(for: type(of: self))
        guard let couch = bundle.url(forResource: "couch-1", withExtension: "ply"),
            let couchPoints = Utils.pointsFromPLY(url: couch) else {
            throw ParsingError.couldNotLoad
        }
        
        let encoder = JSONEncoder()
        
        let data = try? encoder.encode(couchPoints)
        
        let cloud = Cloud(moc: container.viewContext)
        cloud.setPointCloud(pointCloud: data)
        
        try? container.viewContext.save()
        
        let space = Space(moc: container.viewContext, name: "Hello", pointCloud: cloud, location: nil)
        
        try? container.viewContext.save()
        
        var spaceItemInstances = space.getAllItemInstances()
        
        XCTAssert(spaceItemInstances.count == 0)
        
        let item = Item(moc: container.viewContext, name: "Bag")
        try? container.viewContext.save()
        
        let position = Position(moc: container.viewContext, position: simd_float3(x: 1, y: 1, z: 1), space: space)
        try? container.viewContext.save()
        
        // add item instance to position in the space
        let itemInstance = ItemInstance(moc: container.viewContext, item: item, position: position, quantity: 1)
        try? container.viewContext.save()
        
        // add another item instance within the first Item Instance
        let secondItem = Item(moc: container.viewContext, name: "Books")
        try? container.viewContext.save()
        let secondItemInstance = ItemInstance(moc: container.viewContext, item: secondItem, parentInstance: itemInstance, quantity: 2)
        try? container.viewContext.save()
        
        spaceItemInstances = space.getAllItemInstances()
        
        XCTAssert(spaceItemInstances.count == 2)
        XCTAssert(spaceItemInstances.contains(itemInstance))
        XCTAssert(spaceItemInstances.contains(secondItemInstance))
        
        let secondPosition = Position(moc: container.viewContext, position: simd_float3(x: 1, y: 2, z: 3), space: space)
        
        try? container.viewContext.save()
        
        // add another item instance with the same item
        let thirdItemInstance = ItemInstance(moc: container.viewContext, item: item, position: secondPosition, quantity: 2)
        
        try? container.viewContext.save()
        spaceItemInstances = space.getAllItemInstances()
        
        XCTAssert(spaceItemInstances.count == 3)
        XCTAssert(spaceItemInstances.contains(itemInstance))
        XCTAssert(spaceItemInstances.contains(secondItemInstance))
        XCTAssert(spaceItemInstances.contains(thirdItemInstance))
    }
    
    func testGetLocation() throws {
        let container = TestCoreDataStack().persistentContainer
        
        let bundle = Bundle(for: type(of: self))
        guard let couch = bundle.url(forResource: "couch-1", withExtension: "ply"),
            let couchPoints = Utils.pointsFromPLY(url: couch) else {
            throw ParsingError.couldNotLoad
        }
        
        let encoder = JSONEncoder()
        
        let data = try? encoder.encode(couchPoints)
        
        let cloud = Cloud(moc: container.viewContext)
        cloud.setPointCloud(pointCloud: data)
        
        try? container.viewContext.save()
        
        let location = Location(moc: container.viewContext, location: CLLocation(latitude: 10, longitude: 10))
        
        try? container.viewContext.save()
        
        let space = Space(moc: container.viewContext, name: "Hello", pointCloud: cloud, location: location)
        
        try? container.viewContext.save()
        
        XCTAssert(space.getLocation() != nil)
        XCTAssert(space.getLocation()?.coordinate.latitude == 10)
        XCTAssert(space.getLocation()?.coordinate.longitude == 10)
        
        let secondCloud = Cloud(moc: container.viewContext)
        secondCloud.setPointCloud(pointCloud: data)
        try? container.viewContext.save()
        
        let secondSpace = Space(moc: container.viewContext, name: "World!", pointCloud: secondCloud, location: nil)
        try? container.viewContext.save()
        
        XCTAssert(secondSpace.getLocation() == nil)
        
    }
    
    func testSetLocation() throws {
        let container = TestCoreDataStack().persistentContainer
        
        let bundle = Bundle(for: type(of: self))
        guard let couch = bundle.url(forResource: "couch-1", withExtension: "ply"),
            let couchPoints = Utils.pointsFromPLY(url: couch) else {
            throw ParsingError.couldNotLoad
        }
        
        let encoder = JSONEncoder()
        
        let data = try? encoder.encode(couchPoints)
        
        let cloud = Cloud(moc: container.viewContext)
        cloud.setPointCloud(pointCloud: data)
        
        try? container.viewContext.save()
        
        let location = Location(moc: container.viewContext, location: CLLocation(latitude: 10, longitude: 10))
        
        try? container.viewContext.save()
        
        let space = Space(moc: container.viewContext, name: "World!", pointCloud: cloud, location: location)
        
        try? container.viewContext.save()
        
        XCTAssert(space.getLocation() != nil)
        XCTAssert(space.getLocation()?.coordinate.latitude == 10)
        XCTAssert(space.getLocation()?.coordinate.longitude == 10)
        
        let secondLocation = Location(moc: container.viewContext, location: CLLocation(latitude: 20, longitude: 30))
        try? container.viewContext.save()
        
        space.setLocation(location: secondLocation)
        try? container.viewContext.save()
        
        XCTAssert(space.getLocation() != nil)
        XCTAssert(space.getLocation()?.coordinate.latitude == 20)
        XCTAssert(space.getLocation()?.coordinate.longitude == 30)
    }
    
    
    
    
}
