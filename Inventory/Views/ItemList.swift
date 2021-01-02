//
//  ItemList.swift
//  Inventory
//
//  Created by Vincent Spitale on 6/24/20.
//  Copyright © 2020 Vincent Spitale. All rights reserved.
//

import SwiftUI

struct ItemList: View {
    @FetchRequest(entity: Item.entity(), sortDescriptors: []) var items: FetchedResults<Item>
    @EnvironmentObject var controller: InventoryController
    @Binding var itemSearch: String
    
    var body: some View {
        
        let sortedItems = items.sorted(by: {$0.getLastModified() > $1.getLastModified()})
        
        return  VStack() {
            ForEach(sortedItems.filter {
            self.itemSearch.isEmpty ? true :
               ($0.name?.localizedCaseInsensitiveContains(self.itemSearch)) ?? false
        }, id: \.self) { item in
            
                
                ItemPreview(item: item)
                
        }
         }
    
    }
}

