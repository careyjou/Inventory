//
//  ObjectDetail.swift
//  Inventory
//
//  Created by Vincent Spitale on 5/3/20.
//  Copyright © 2020 Vincent Spitale. All rights reserved.
//

import SwiftUI
import SceneKit

struct ItemDetail: View {
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var controller: InventoryController
    @ObservedObject var item: Item
    
    @State private var isShowingEditView = false


    
    

    func name() -> String {
        return item.getName() ?? ""
    }
    

    
    func options() -> some View {
        
        return
            VStack(alignment: .leading){
                    
            HStack{
                Button(action: { self.isShowingEditView.toggle()}) {
                    Label("Edit Item", systemImage: "pencil")
                }
                .font(Font.system(.subheadline).bold())
                .buttonStyle(RoundedButton(textColor: .primary, cornerRadius: 10))
                .sheet(isPresented: $isShowingEditView) {
                    ItemEditView(item: item, isShowingEditView: self.$isShowingEditView)
                }
                Spacer()
                                    
            }
            .frame(maxWidth: 700)
            .padding(.horizontal)
            }
        
        
    }
    
    func content() -> some View {
        
        return VStack{
                    
                    HStack{
                        Text("Quantity")
                            .bold()
                            .padding()
 
                        Spacer()
                        Text(String(item.getQuantity()))
                            .foregroundColor(Color.secondary)
                            .padding()
                        
                    }.frame(maxWidth: 700)
                    
                    
                    
                    
                    HStack{
                        Spacer()
                    }
                    
                
                self.itemInstancesGrid(item: item)
                
                }
               .padding(.top)

            }
    
    func overlay() -> some View {
        
        return VStack {
            Spacer()
            HStack(){
                Menu{
                    Button(action: {}) {
                        Label("Add to Existing Item", systemImage: "bag.fill")
                    }
                    Button(action: {}) {
                        Label("Add in AR", systemImage: "arkit")
                    }
                } label: {
                    Button(action: {}) {
                        Image(systemName: "plus")
                    }
                    .buttonStyle(CircleButton())
                    .accessibility(label: Text("Add Instance"))
                }

                Spacer()
                if (item.hasPosition()) {
                    Button(action: {self.controller.showFind()})
                {
                    Image(systemName: "magnifyingglass")
                }.buttonStyle(CircleButton())
                .accessibility(label: Text("Find Item"))
                
            }
            }
        }

    }
    
    

    
    var body: some View {
        
        return self.combined()
    }
    
    @ViewBuilder func combined() -> some View {
        ZStack{
            ScrollView(.vertical) {
                VStack {
                    self.options().frame(maxWidth: 700).padding(.top, 10)
                    self.content().frame(maxWidth: 700)
                    HStack{
                        Spacer()
                    }
                }
            }
            self.overlay()
        }
        .navigationBarTitle(Text(self.name()))
            
        
    }
    

        
    
    
    private func itemInstancesGrid(item: Item) -> some View {
        let instances: [ItemInstance] = item.getInstances()
        
        let layout = [
            GridItem(.adaptive(minimum: 150, maximum: 300))
        ]
        
        return
            LazyVGrid(columns: layout) {
            ForEach(instances, id: \.self) { instance in
        
                NavigationLink(destination: ItemInstanceDetail(instance: instance)) {
                    if (instance.getSpace() != nil) {
            HStack{
                VStack(alignment: .leading){
                    if let name = instance.getSpace()?.name {
                        Text(name)
                    }
                    Text(String(instance.getQuantity()) + Utils.singularPluralLanguage(int: instance.getQuantity(), singular: " item", plural: " items"))
                        .font(Font.system(.body))
                }
                Spacer()
            }
                    }
                    
                    else {
                        HStack{
                            VStack(alignment: .leading) {
                                Text("Some Instance")
                                Text(String(instance.getQuantity()) + Utils.singularPluralLanguage(int: instance.getQuantity(), singular: " item", plural: " items"))
                                    .font(Font.system(.body))
                            }
                            Spacer()
                        }
                        
                        }
                    
        }
        .buttonStyle(RoundedButton(textColor: .primary, cornerRadius: 10))
        .padding(5)
    }
            .padding(.horizontal)
    }
    }
    
    
    

    
    
    
}
