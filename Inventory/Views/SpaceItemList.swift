//
//  SpaceItemList.swift
//  Inventory
//
//  Created by Vincent Spitale on 11/27/20.
//  Copyright © 2020 Vincent Spitale. All rights reserved.
//

import SwiftUI

struct SpaceItemList: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var space: Space
    @Binding var selection: Findable?
    @State var search: String = ""
    
    
    var body: some View {
            let itemInstances = space.getAllItemInstances()
        
            return
                ScrollView {
                VStack {
                    SearchBar(text: $search, label: "Search Items")
                        .padding()
                    ForEach(itemInstances.filter({self.search.isEmpty ? true : ($0.getName()?.localizedCaseInsensitiveContains(search) ?? false)}), id: \.self) { instance in
                if instance == selection as? ItemInstance {
                    Button(action: {self.setfinding(instance: instance)}) {
                        Text(instance.getName() ?? "")
                    }
                    .buttonStyle(NavigationButton(backgroundColor: Color(.systemGray4)))
                }
                else {
                    Button(action: {self.setfinding(instance: instance)}) {
                        Text(instance.getName() ?? "")
                    }
                    .buttonStyle(NavigationButton(backgroundColor: Color(.clear)))
                }
            }
                    
                    Spacer()
                }
                }
        
    }
    
    
    private func setfinding(instance: ItemInstance) {
        selection = instance
        presentationMode.wrappedValue.dismiss()
    }
    
}

