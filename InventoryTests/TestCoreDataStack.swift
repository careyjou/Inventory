//
//  TestCoreDataStack.swift
//  InventoryTests
//
//  Created by Vincent Spitale on 2/17/21.
//  Copyright © 2021 Vincent Spitale. All rights reserved.
//

import Foundation
import CoreData
@testable import Inventory

class TestCoreDataStack {
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Inventory")

      let description = NSPersistentStoreDescription()
      description.url = URL(fileURLWithPath: "/dev/null")
      container.persistentStoreDescriptions = [description]

      container.loadPersistentStores(completionHandler: { _, error in
        if let error = error as NSError? {
          fatalError("Failed to load stores: \(error), \(error.userInfo)")
        }
      })

      return container
    }()
    
    
}
