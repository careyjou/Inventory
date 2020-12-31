//
//  ItemInstanceHierarchy.swift
//  Inventory
//
//  Created by Vincent Spitale on 12/21/20.
//  Copyright © 2020 Vincent Spitale. All rights reserved.
//

import SwiftUI

struct ItemInstanceHierarchy: View {
    @ObservedObject var instance: ItemInstance
    
    var body: some View {
        if let directSubItems = instance.directSubItems {
            List(directSubItems, children: \.directSubItems) { instance in
                NavigationLink(destination: ItemInstanceDetail(instance: instance)) {
                    if let name = instance.getName() {
                    Text(name)
                    }
                }
            }.navigationTitle(Text(instance.getName() ?? ""))
        }
    }
}

