//
//  NestedAddItemInstanceView.swift
//  Inventory
//
//  Created by Vincent Spitale on 2/2/21.
//  Copyright © 2021 Vincent Spitale. All rights reserved.
//

import Foundation


/// Used to add an item instance within another item instance
struct NestedAddItemInstanceView {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var viewModel: InventoryViewModel
    
    @ObservedObject var item: Item
    
    @Binding var parentInstance: ItemInstance? = nil
    @State private var quantity = ""
    
    var body: some View {
        return NavigationView{
            ScrollView{
                VStack{
                    Text(item.getName())
                    
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
                    
                }
                .padding()
            }
            .navigationBarTitle(Text("Add Item Instance"), displayMode: .inline)
            .navigationBarItems(leading:
                                    Button(action: { presentationMode.wrappedValue.dismiss()}) {
                    Image(systemName: "xmark")
                }
                .buttonStyle(SecondaryCircleButton()),
                                trailing:
                                if (parentInstance.wrappedValue != nil) {
                    Button(action: {
                        
                    }) {
                        Image(systemName: "checkmark")
                    }
                    .buttonStyle(SecondaryCircleButton())
                                }
                                else {
                                EmptyView()
                                })
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}


