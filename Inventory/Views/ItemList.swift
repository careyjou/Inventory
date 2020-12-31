//
//  ItemList.swift
//  Inventory
//
//  Created by Vincent Spitale on 6/24/20.
//  Copyright © 2020 Vincent Spitale. All rights reserved.
//

import SwiftUI

struct ItemList: View {
    @FetchRequest(entity: Item.entity(), sortDescriptors: [NSSortDescriptor(key: "createdAt", ascending: false)]) var items: FetchedResults<Item>
    @Binding var itemSearch: String
    @EnvironmentObject var controller: InventoryController
    
    
    var body: some View {
        
        
        return  LazyVStack() {
            ForEach(items.filter {
            self.itemSearch.isEmpty ? true :
                $0.name!.localizedCaseInsensitiveContains(self.itemSearch)
        }, id: \.self) { item in
            
                
                ItemPreview(item: item)
                
        }
    }
    }
}

