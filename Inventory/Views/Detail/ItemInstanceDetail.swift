//
//  ItemInstanceDetail.swift
//  Inventory
//
//  Created by Vincent Spitale on 7/19/20.
//  Copyright © 2020 Vincent Spitale. All rights reserved.
//

import SwiftUI
import ARKit

struct ItemInstanceDetail: View {
    
    @ObservedObject var instance : ItemInstance
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var controller: InventoryViewModel
    @State private var isShowingEditView = false
    @State private var isShowing3DView = false
    @State private var isShowingNestedReposition = false

    
    func name() -> String {
        return instance.getName() ?? ""

    }
    
    
    func options() -> some View {
        
        return VStack(alignment: .leading){
                
                if !instance.getParents().isEmpty || (instance.getSpace() != nil) {
                    HStack{
                    if let space = instance.getSpace() {
                        Text(Image(systemName: "chevron.right")).foregroundColor(.secondary)
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
                    .sheet(isPresented: ($isShowingEditView)) {
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
                    if let date = instance.getLastModified() {
                    Text(formatter.string(from: date))
                        .foregroundColor(Color.secondary)
                        .padding()
                    }
                    
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
            .sheet(isPresented: $isShowingNestedReposition) {
                NestedRepositionItemInstanceView(instance: instance)
            }
        
    
    }
    
    
    func overlay() -> some View {
       
        
        return
            VStack {
                Spacer()
                HStack(){
                    
                    Menu(){
                        #if !(targetEnvironment(macCatalyst) || targetEnvironment(simulator))
                        
                        if (ARWorldTrackingConfiguration.supportsFrameSemantics(.sceneDepth)) {
                        Button(action: {self.controller.showReposition(instance: instance)}) {
                            Label("Reposition in AR", systemImage: "arkit")
                        }
                        }
                        #endif
                        Button(action: {self.isShowingNestedReposition = true}) {
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
                    
                    if let space = instance.getSpace(),
                    let data = (UIApplication.shared.delegate as? AppDelegate)?.data {
                        NavigationLink(destination: Space3D(space: space, data: data, itemSelection: instance), isActive: $isShowing3DView) {
                            EmptyView()
                        }
                    }
                    
                    #if !(targetEnvironment(macCatalyst) || targetEnvironment(simulator))
                    if (instance.getSpace() != nil && ARWorldTrackingConfiguration.supportsFrameSemantics(.sceneDepth)) {
                        Button(action: {self.controller.showFind(finding: instance)})
                        {
                            Image(systemName: "magnifyingglass")
                        }.buttonStyle(CircleButton())
                        .contextMenu {
                                Button(action: {self.isShowing3DView = true}) {
                                Label("3D Viewer", systemImage: "view.3d")
                            }
                            
                        }
                        
                    }
                    else if (instance.getSpace() != nil) {
                        Button(action: {self.isShowing3DView = true}) {
                            Image(systemName: "view.3d")
                        }.buttonStyle(CircleButton())
                        
                    }
                    #endif
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
        
        let item = Item(moc: moc, name: "Green Bag")
        let instance = ItemInstance(moc: moc, item: item, position: nil, quantity: 1)
        instance.item = item
        
        
        let subItem = Item(moc: moc, name: "Small Bag")
        subItem.createdAt = Date()
        let subInstance = ItemInstance(moc: moc, item: subItem, position: nil, quantity: 1)
        _ = subInstance.setParent(instance: instance)
        
        let subItem2 = Item(moc: moc, name: "iPad")
        let subInstance2 = ItemInstance(moc: moc, item: subItem2, position: nil, quantity: 1)
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

