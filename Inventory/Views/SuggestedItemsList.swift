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
    @FetchRequest(entity: ItemInstance.entity(), sortDescriptors: [NSSortDescriptor(key: "lastModified", ascending: false)]) var items: FetchedResults<ItemInstance>
    
    var body: some View {
        
        
        let suggestedItems = items.prefix(3)
        
        return VStack{
            ForEach(suggestedItems, id: \.self) { instance in
            NavigationLink(destination: ItemInstanceDetail(instance: instance)) {
                ItemInstancePreview(instance: instance)
                
            }
            .buttonStyle(NavigationButton())
        }
        }
    }
}


