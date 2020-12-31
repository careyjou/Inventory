//
//  EditView.swift
//  Inventory
//
//  Created by Vincent Spitale on 5/10/20.
//  Copyright © 2020 Vincent Spitale. All rights reserved.
//

import SwiftUI
import Combine

struct ItemEditView: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var item: Item
    
    @State private var newName: String = ""
    
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
        
                if let name = item.name {
                    self.newName = name
                }
        
    }
    
    
    private func updateItem() {
        
        _ = item.setName(newName: self.newName)
        try? moc.save()
        
   
        self.presentationMode.wrappedValue.dismiss()
    }
    
    private func delete() {
        moc.delete(item)
        try? moc.save()
        self.presentationMode.wrappedValue.dismiss()
    
    }
    
    
    
    
}


