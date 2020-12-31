//
//  SpaceItemList.swift
//  Inventory
//
//  Created by Vincent Spitale on 11/27/20.
//  Copyright © 2020 Vincent Spitale. All rights reserved.
//

import SwiftUI

struct SpaceItemList: View {
    @ObservedObject var space: Space
    @Binding var selection: ItemInstance?
    @State var search: String = ""
    
    
    var body: some View {
            let itemInstances = space.getAllItemInstances()
            ForEach(itemInstances, id: \.self) { instance in
                if instance == selection {
                    Button(action: {}) {
                        Text(instance.getName() ?? "")
                    }
                    .buttonStyle(NavigationButton(backgroundColor: Color(.gray)))
                }
                else {
                    Button(action: {}) {
                        Text(instance.getName() ?? "")
                    }
                    .buttonStyle(NavigationButton(backgroundColor: Color(.clear)))
                }
            }
        
        
        
    }
}

