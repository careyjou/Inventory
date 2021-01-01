//
//  ItemInstanceDetail.swift
//  Inventory
//
//  Created by Vincent Spitale on 7/19/20.
//  Copyright © 2020 Vincent Spitale. All rights reserved.
//

import SwiftUI

struct ItemInstanceDetail: View {
    
    @ObservedObject var instance : ItemInstance
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var controller: InventoryController
    @State private var isShowingEditView = false
    

    
    func name() -> String {
        return instance.getName() ?? ""

    }
    
    
    func options() -> some View {
        
        return VStack(alignment: .leading){
                
                if !instance.getParents().isEmpty || (instance.getSpace() != nil) {
                    HStack{
                    if let space = instance.getSpace() {
                            NavigationLink(destination: SpaceDetail(space: space)) {
                                Text(space.getName() ?? "").foregroundColor(.primary)
                            }
                        }
                    if let parents = instance.getParents() {
                    if !parents.isEmpty {
                        ForEach(parents, id: \.self) {
                            parentInstance in
                            Text(Image(systemName: "chevron.right")).foregroundColor(.secondary)
                            NavigationLink(destination: ItemInstanceDetail(instance: parentInstance)) {
                            InstanceTextPreview(instance: parentInstance).foregroundColor(.secondary)
                            }
                        }
    
                    }
                        Spacer()
                    }
                    }
                    .padding(.horizontal)
                    .padding(.bottom)
                }
                
                HStack{
                    if let item = instance.item {
                    NavigationLink(destination: ItemDetail(item: item)) {
                        Label("All Instances", systemImage: "square.stack.3d.down.right")
                    }
                    .font(Font.system(.subheadline).bold())
                    .buttonStyle(RoundedButton(textColor: .primary, cornerRadius: 10))
                    .padding(.trailing, 10)
                    
                    
                    Button(action: { self.isShowingEditView.toggle()}) {
                        Label("Edit Instance", systemImage: "pencil")
                    }
                    .font(Font.system(.subheadline).bold())
                    .buttonStyle(RoundedButton(textColor: .primary, cornerRadius: 10))
                    .sheet(isPresented: $isShowingEditView) {
                        ItemInstanceEditView(instance: instance, isShowingEditView: self.$isShowingEditView)
                    }
                    .padding(.trailing, 10)
                    }
                    
                    
                    Spacer()
                    
                }
                .frame(maxWidth: 700)
                .padding(.horizontal)
            }
        }
        
        
    
    
    func content() -> some View {
        
        let shortFormatter: DateFormatter = DateFormatter()
        shortFormatter.dateStyle = .short
        
        let formatter: DateFormatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        
        return
            VStack {
                
                
                HStack{
                    Text("Quantity")
                        .bold()
                        .padding()
                    Button(action: {instance.subOneQuantity()}) {
                        Image(systemName: "minus")
                            .frame(width: 10, height: 10)
                    }
                    .buttonStyle(RoundedButton(textColor: .primary, cornerRadius: 10))
                    
                    Button(action: {instance.addOneQuantity()}) {
                        Image(systemName: "plus")
                            .frame(width: 10, height: 10)
                        
                    }
                    .buttonStyle(RoundedButton(textColor: .primary, cornerRadius: 10))
                    
                    Spacer()
                    Text(String(instance.getQuantity()))
                        .foregroundColor(Color.secondary)
                        .padding()
                    
                }.frame(maxWidth: 700)
                
                
                
                HStack{
                    Text("Last Moved")
                        .bold()
                        .padding()
                    Spacer()
                    Text(formatter.string(from: instance.getLastModified()))
                        .foregroundColor(Color.secondary)
                        .padding()
                    
                }.frame(maxWidth: 700)
                
                
                
                
                
                if !instance.getSubItems().isEmpty {
                    Divider()
                    VStack{
                        HStack{
                            Text("Inner Items")
                                .font(.title2)
                                .bold()
                                .padding()
                            Spacer()
                            NavigationLink(destination: ItemInstanceHierarchy(instance: instance)) {
                                Label("View Hierarchy", systemImage: "bag.fill")
                            }.buttonStyle(RoundedButton(textColor: .primary, cornerRadius: 10))
                            .padding(.horizontal)
                        }
                        
                        ForEach(instance.getSubItems(), id: \.self) {
                            instance in
                            NavigationLink(destination: ItemInstanceDetail(instance: instance)) {
                                if let name = instance.getName() {
                                Text(name)
                                }
                            }
                            .buttonStyle(NavigationButton())
                        }
                        .padding(.horizontal)
                        
                    }
                }
                

                
                
                HStack{
                    Spacer()
                }
                
                
                
            }
            .padding(.top)
        
    
    }
    
    
    func overlay() -> some View {
       
        
        return
            VStack {
                Spacer()
                HStack(){
                    
                    Menu{
                        Button(action: {self.controller.showReposition()}) {
                            Label("Reposition in AR", systemImage: "arkit")
                        }
                        Button(action: {}) {
                            Label("Place in Existing Item", systemImage: "bag.fill")
                        }
                    } label: {
                    
                    Button(action: {})
                    {
                        Image(systemName: "move.3d")
                    }.buttonStyle(CircleButton())
                    .accessibility(label: Text("Reposition"))
                    }
                    Spacer()
                    if (instance.getSpace() != nil) {
                        Button(action: {self.controller.showFind()})
                        {
                            Image(systemName: "magnifyingglass")
                        }.buttonStyle(CircleButton())
                        
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
    
    
    
    
    
    
    
}


struct ItemInstance_Previews: PreviewProvider {
    
    static var previews: some View {
        let moc = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let item = Item(context: moc)
        item.id = UUID()
        item.name = "Green Bag"
        item.createdAt = Date()
        let instance = ItemInstance(context: moc).setID().setDate().setQuantity(newQuantity: 1)
        instance.item = item
        
        
        let subItem = Item(context: moc).setID().setName(newName: "Small Bag")
        subItem.createdAt = Date()
        let subInstance = ItemInstance(context: moc).setID().setDate().setQuantity(newQuantity: 1)
        subInstance.item = subItem
        _ = subInstance.setParent(instance: instance)
        
        let subItem2 = Item(context: moc).setID().setName(newName: "iPad")
        subItem2.createdAt = Date()
        let subInstance2 = ItemInstance(context: moc).setID().setDate().setQuantity(newQuantity: 1)
        subInstance2.item = subItem2
        _ = subInstance2.setParent(instance: subInstance)
        
        
        return
            NavigationView{
            ItemInstanceDetail(instance: instance)
            }
    }
}

struct InstanceTextPreview: View {
    @ObservedObject var instance: ItemInstance
    
    var body: some View {
        Text(instance.getName() ?? "")
    }
    
}

