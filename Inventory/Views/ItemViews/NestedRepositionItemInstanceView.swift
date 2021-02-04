//
//  NestedRepositionItemInstanceView.swift
//  Inventory
//
//  Created by Vincent Spitale on 2/3/21.
//  Copyright © 2021 Vincent Spitale. All rights reserved.
//

import SwiftUI

struct NestedRepositionItemInstanceView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: ItemInstance.entity(), sortDescriptors: []) var items: FetchedResults<ItemInstance>
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var viewModel: InventoryViewModel
    
    @ObservedObject var instance: ItemInstance
    
    @State var parentInstance: ItemInstance? = nil
    // state of the item search field for selecting an item instance to add another instance to
    @State private var itemSearch = ""
    
    var body: some View {
        return NavigationView{
            ScrollView{
                VStack{
                    HStack{
                        Text(instance.getName() ?? "").font(.title).bold()
                        if let parentName = parentInstance?.getName() {
                            Text(Image(systemName: "chevron.right")).foregroundColor(.secondary).font(.title).bold()
                            Text(parentName).font(.title).bold()
                        }
                        Spacer()
                    }
                    
                    // Items Selection
                    
                    // Search Item Instances
                    
                    SearchBar(text: $itemSearch, label: "Search Items")
                        .frame(maxWidth: 700)
                        .padding(.top, 5)
                    
                    
                    let sortedItems = items.sorted(by: {$0.getLastModified() > $1.getLastModified()}).filter({$0 != self.instance})
                    
                    // Item Instance List
                    ForEach(sortedItems.filter({self.itemSearch.isEmpty ? true :
                        ($0.getName()?.localizedCaseInsensitiveContains(self.itemSearch)) ?? false
                 }), id: \.self) { item in
                            // differentiate if selected
                            if (item == self.parentInstance) {
                                Button(action: {self.parentInstance = item}) {
                                    ItemInstancePreview(instance: item, isDetailed: true)
                                }
                                .buttonStyle(NavigationButton(backgroundColor: .accentColor, isSpaced: false))
                            }
                            else {
                            Button(action: {self.parentInstance = item}) {
                                ItemInstancePreview(instance: item, isDetailed: true)
                            }
                            .buttonStyle(NavigationButton(isSpaced: false))
                            }
                        
                    }
                    
                    
                }
                .padding()
            }
            .navigationBarTitle(Text("Reposition Item"), displayMode: .inline)
            .navigationBarItems(leading:
                                    Button(action: { presentationMode.wrappedValue.dismiss()}) {
                    Image(systemName: "xmark")
                }
                .buttonStyle(SecondaryCircleButton()),
                                trailing: self.checkmark())
                                
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    /// Conditionally show checkmark button
    /// - Returns: Checkmark button if applicable
    @ViewBuilder func checkmark() -> some View {
        if (self.parentInstance != nil) {
        Button(action: {
            self.setParent()
        }) {
        Image(systemName: "checkmark")
        }
        .buttonStyle(SecondaryCircleButton())
        }
        else {
        EmptyView()
        }
    }
    
    
    /// Save new instance within existing item instance
    func setParent() {
        
        guard let parent = parentInstance else {
            return
        }
        
        // add parent to instance
        _ = instance.setParent(instance: parent)
        
        try? moc.save()
        self.presentationMode.wrappedValue.dismiss()
    }
    
    
}


