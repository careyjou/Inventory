//
//  NestedAddNewItemInstanceView.swift
//  Inventory
//
//  Created by Vincent Spitale on 2/2/21.
//  Copyright © 2021 Vincent Spitale. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

/// Used to add an item instance within another item instance
struct NestedAddNewItemInstanceView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: Item.entity(), sortDescriptors: []) var items: FetchedResults<Item>
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var viewModel: InventoryViewModel
    
    @ObservedObject var item: Item
    
    @State var parentInstance: ItemInstance? = nil
    @State private var quantity = ""
    // state of the item search field for selecting an item instance to add another instance to
    @State private var itemSearch = ""
    
    var body: some View {
        return NavigationView{
            ScrollView{
                VStack{
                    HStack{
                        Text(item.getName() ?? "").font(.title).bold()
                        if let parentName = parentInstance?.getName() {
                            Text(Image(systemName: "chevron.right")).foregroundColor(.secondary).font(.title).bold()
                            Text(parentName).font(.title).bold()
                        }
                        Spacer()
                    }
                    HStack{
                        Text("Quantity")
                            .bold()
                        TextField("1", text: $quantity)
                            .multilineTextAlignment(.trailing)
                            .keyboardType(.numberPad)
                            .onReceive(Just(quantity)) { newValue in
                                let filtered = newValue.filter { "0123456789".contains($0) }
                                if filtered != newValue {
                                    self.quantity = filtered
                                }
                        }
                        
                    }
                    
                    // Items Selection
                    
                    // Search Item Instances
                    
                    SearchBar(text: $itemSearch, label: "Search Items")
                        .frame(maxWidth: 700)
                        .padding(.top, 5)
                    
                    
                    let sortedItems = items.sorted(by: {$0.getLastModified() > $1.getLastModified()})
                    
                    // Item Instance List
                    ForEach(sortedItems.filter({self.itemSearch.isEmpty ? true :
                        ($0.name?.localizedCaseInsensitiveContains(self.itemSearch)) ?? false
                 }), id: \.self) { item in
                        let instances = item.getInstances()
                        ForEach(instances, id: \.self) { instance in
                            // differentiate if selected
                            if (instance == self.parentInstance) {
                                Button(action: {self.parentInstance = instance}) {
                                    ItemInstancePreview(instance: instance, isDetailed: true)
                                }
                                .buttonStyle(NavigationButton(backgroundColor: .accentColor, isSpaced: false))
                            }
                            else {
                            Button(action: {self.parentInstance = instance}) {
                                ItemInstancePreview(instance: instance, isDetailed: true)
                            }
                            .buttonStyle(NavigationButton(isSpaced: false))
                            }
                        }
                    }
                    
                    
                }
                .padding()
            }
            .navigationBarTitle(Text("Add Item Instance"), displayMode: .inline)
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
            self.saveItem()
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
    func saveItem() {
        let intQuantity = self.quantity.isEmpty ? 1: (Int(self.quantity) ?? 0)
        
        guard let parent = parentInstance else {
            return
        }
        
        _ = ItemInstance(moc: moc, item: item, parentInstance: parent, quantity: intQuantity)
        try? moc.save()
        self.presentationMode.wrappedValue.dismiss()
    }
    
}


