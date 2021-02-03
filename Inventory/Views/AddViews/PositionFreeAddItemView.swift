//
//  PositionlessAddItemView.swift
//  Inventory
//
//  Created by Vincent Spitale on 1/16/21.
//  Copyright © 2021 Vincent Spitale. All rights reserved.
//

import SwiftUI

struct PositionFreeAddItemView: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var viewModel: InventoryViewModel
    
    @State private var name = ""
    
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
                        self.saveItem()
                    }) {
                        Image(systemName: "checkmark")
                    }
                    .buttonStyle(SecondaryCircleButton()))
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    func saveItem() {
        _ = Item(moc: moc, name: name)
        try? moc.save()
    }
    
}

struct PositionFreeAddItemView_Previews: PreviewProvider {
    static var previews: some View {
        PositionFreeAddItemView()
    }
}
