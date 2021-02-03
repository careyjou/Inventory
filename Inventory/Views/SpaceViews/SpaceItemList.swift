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
        var itemInstances = space.getAllItemInstances()
        
        itemInstances.sort(by: {$0.getLastModified() > $1.getLastModified()})
        
            return
                ScrollView {
                VStack {
                    SearchBar(text: $search, label: "Search Items")
                        .padding()
                    VStack {
                    ForEach(itemInstances.filter({self.search.isEmpty ? true : ($0.getName()?.localizedCaseInsensitiveContains(search) ?? false)}), id: \.self) { instance in
                if instance == selection as? ItemInstance {
                    Button(action: {self.setfinding(instance: instance)}) {
                        Text(instance.getName() ?? "")
                            .foregroundColor(Color(.white))
                    }
                    .buttonStyle(NavigationButton(backgroundColor: .accentColor))
                }
                else {
                    Button(action: {self.setfinding(instance: instance)}) {
                        Text(instance.getName() ?? "")
                    }
                    .buttonStyle(NavigationButton(backgroundColor: Color(.clear)))
                }
            }
                    }.padding(.horizontal, 5)
                    
                    Spacer()
                }
                }
        
    }
    
    
    private func setfinding(instance: ItemInstance) {
        selection = instance
        presentationMode.wrappedValue.dismiss()
    }
    
}

