//
//  ItemPreview.swift
//  Inventory
//
//  Created by Vincent Spitale on 12/21/20.
//  Copyright © 2020 Vincent Spitale. All rights reserved.
//

import SwiftUI

struct ItemPreview: View {
    @ObservedObject var item: Item
    
    var body: some View {
        if (item.getInstances().count == 1) {
            NavigationLink(destination: ItemInstanceDetail(instance: item.getInstances().first!)) {
                if let name = item.name {
                Text(name)
                }
            }
            .buttonStyle(NavigationButton())
            
        }
        
        else {
        
            NavigationLink(destination: ItemDetail(item: item)) {
            
            if let name = item.name {
            Text(name)
            }
            
            
        }
        .buttonStyle(NavigationButton())
    }
    }
}


