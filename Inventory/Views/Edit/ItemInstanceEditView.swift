//
//  ItemInstanceEditView.swift
//  Inventory
//
//  Created by Vincent Spitale on 7/19/20.
//  Copyright © 2020 Vincent Spitale. All rights reserved.
//

import SwiftUI
import Combine

struct ItemInstanceEditView: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var instance: ItemInstance
    
    @State private var newName: String = ""
    @State private var newQuantity: String = ""
    @State private var oldQuantity: String = ""
    
    @Binding var isShowingEditView: Bool
    
    var body: some View {
        return NavigationView{
            ScrollView{
                VStack(){
                    HStack{
                        Text("Name")
                            .bold()
                        TextField("Name", text:$newName)
                            .multilineTextAlignment(.trailing)
                    }
                    Divider()
                    HStack{
                        Text("Quantity")
                            .bold()
                        TextField(String(oldQuantity), text: $newQuantity)
                            .multilineTextAlignment(.trailing)
                            .keyboardType(.numberPad)
                            .onReceive(Just(newQuantity)) { newValue in
                                let filtered = newValue.filter { "0123456789".contains($0) }
                                if filtered != newValue {
                                    self.newQuantity = filtered
                                }
                        }
                        
                    }
                    
                    
                }
                .padding()
            }
            .navigationBarTitle(Text("Edit Item"), displayMode: .inline)
            .navigationBarItems(leading:
                                    HStack{
                Button(action: { self.isShowingEditView = false}) {
                    Image(systemName: "xmark")
                }
                .buttonStyle(SecondaryCircleButton())
                                        Button(action: {self.delete()}) {
                                            Image(systemName: "trash")
                                                .foregroundColor(.red)
                                        }
                                        .buttonStyle(SecondaryCircleButton())
                                        
                                    },
                                trailing:
                Button(action: { self.updateItem()}) {
                    Image(systemName: "checkmark")
                }
                .buttonStyle(SecondaryCircleButton()))
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear {
            self.initdata()
        }
    }
    
    
    private func initdata() {
        
        if let name = instance.getName() {
                    self.newName = name
        }
        self.oldQuantity = String(instance.getQuantity())
        
            
        
    }
    
    
    private func updateItem() {
        
        _ = instance.item?.setName(newName: self.newName)
        
        
        
        _ = instance.setQuantity(newQuantity: self.newQuantity.isEmpty ? instance.getQuantity(): (Int(newQuantity) ?? 0))

        try? moc.save()
   
        self.presentationMode.wrappedValue.dismiss()
    }
    
    private func delete() {
        moc.delete(instance)
        try? moc.save()
        self.presentationMode.wrappedValue.dismiss()
    
    }
    
    
    
    
}


