//
//  SuggestedItemsList.swift
//  Inventory
//
//  Created by Vincent Spitale on 6/26/20.
//  Copyright © 2020 Vincent Spitale. All rights reserved.
//

import SwiftUI
import CoreData

struct SuggestedItemsList: View {
    @EnvironmentObject var controller: InventoryController
    @FetchRequest(entity: ItemInstance.entity(), sortDescriptors: [NSSortDescriptor(key: "lastModified", ascending: false)]) var items: FetchedResults<ItemInstance>
    
    var body: some View {
        
        
        let suggestedItems = items.prefix(3)
        
        return ForEach(suggestedItems, id: \.id) { instance in
            NavigationLink(destination: ItemInstanceDetail(instance: instance).onAppear {
                controller.selectedItem = instance.item
            }) {
                ItemInstancePreview(instance: instance)
                
            }
            .buttonStyle(NavigationButton())
        }
    }
}


