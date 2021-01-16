//
//  AddItemView.swift
//  Inventory
//
//  Created by Vincent Spitale on 5/11/20.
//  Copyright © 2020 Vincent Spitale. All rights reserved.
//

import SwiftUI
import Combine
import CoreData

struct AddItemView: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var controller: InventoryController
    
    @State private var name = ""
    @State private var quantity = ""
    
    
    var body: some View {
        return NavigationView{
            ScrollView{
                VStack(){
                    HStack{
                        Text("Name")
                            .bold()
                        TextField("Name", text:$name)
                            .multilineTextAlignment(.trailing)
                    }
                    Divider()
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
            .navigationBarTitle(Text("Add Item"), displayMode: .inline)
            .navigationBarItems(leading:
                                    Button(action: { presentationMode.wrappedValue.dismiss()}) {
                    Image(systemName: "xmark")
                }
                .buttonStyle(SecondaryCircleButton()),
                                trailing:
                    Button(action: {
                        #if !(targetEnvironment(macCatalyst) || targetEnvironment(simulator))
                        self.addItem()
                        #endif
                        
                    }) {
                        Image(systemName: "checkmark")
                    }
                    .buttonStyle(SecondaryCircleButton()))
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    #if !(targetEnvironment(macCatalyst) || targetEnvironment(simulator))
    func addItem() {
        let item = Item(context: moc).setID().setName(newName: name)
        item.createdAt = Date()
        
        let instance = ItemInstance(context: moc).setQuantity(newQuantity: self.quantity.isEmpty ? 1: (Int(self.quantity) ?? 0)).setDate().setID()
        
        instance.item = item
        
        if let space = controller.arCoordinator?.getSpace(),
           let position = controller.itemPosition {
            let pos = Position(context: moc).setID().setPosition(position: position).setSpace(space: space)
            _ = instance.setDate().setPosition(position: pos)
        }
        
        try? moc.save()
        
        //withAnimation{self.isShowingAR = false}
        self.presentationMode.wrappedValue.dismiss()
    }
    #endif
    
    
}


