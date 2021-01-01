//
//  SpaceDetail.swift
//  Inventory
//
//  Created by Vincent Spitale on 5/17/20.
//  Copyright © 2020 Vincent Spitale. All rights reserved.
//

import SwiftUI

struct SpaceDetail: View {
    
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var space: Space
    
    
    @State private var isShowingEditView = false
    @State private var itemSearch = ""
    
    

    
    func name() -> String {
        return space.getName() ?? ""
    }
    
    
    
    func options() -> some View {
        
        return
            VStack(alignment: .leading){
            
            HStack{
                /*
                Button(action: {}) {
                    Label("Manage Access", systemImage: "person.2.fill")
                }
                .font(Font.system(.subheadline).bold())
                .buttonStyle(RoundedButton(textColor: .primary, cornerRadius: 10))
                .padding(.trailing, 10)
                */
                
                
                Button(action: { self.isShowingEditView.toggle()}) {
                    Label("Edit Space", systemImage: "pencil")
                }
                .font(Font.system(.subheadline).bold())
                .buttonStyle(RoundedButton(textColor: .primary, cornerRadius: 10))
                .padding(.trailing, 10)
                Spacer()
                
            }
            .frame(maxWidth: 700)
            .padding(.horizontal)
            }
        
    }
    
    func content() -> some View {
        
        return
            VStack(alignment: .leading){
                
                
            if (!space.getAllItemInstances().isEmpty) {
                
                
                VStack(alignment: .leading) {
                    SearchBar(text: $itemSearch, label: "Search Items")
                        .frame(maxWidth: 700)
                        .padding(.horizontal)
                    self.itemList(space: space)
                        .padding(.horizontal, 5)
                }.frame(maxWidth: 700)
                    
                }
                
                
                HStack {
                    Spacer()
                }
            }
        
    }
        
    
    
    func overlay() -> some View {
        return VStack {
                Spacer()
                HStack(){
                    Spacer()
                    
                    NavigationLink(destination: Space3D(space: space, data: (UIApplication.shared.delegate as! AppDelegate).data))
                    {
                        Image(systemName: "view.3d")
                    }.buttonStyle(CircleButton())
                    
                
                }
            }
        
    }
    
    
    
    
    var body: some View {
        
        return self.combined()
            .sheet(isPresented: $isShowingEditView) {
                SpaceEditView(space: space, isShowingEditView: $isShowingEditView)
            }
        
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
    
    
    private func itemList(space: Space) -> some View {
        

        var items = space.getAllItemInstances()
        
        items = items.filter {
            self.itemSearch.isEmpty ? true :
                $0.getName()!.localizedCaseInsensitiveContains(self.itemSearch)
        }
        
        items.sort(by: { $0.getLastModified() > $1.getLastModified() })
        return ForEach(items, id: \.self) { item in
            NavigationLink(destination: ItemInstanceDetail(instance: item)) {
                Text(item.getName() ?? "")
                    .font(.body)
                    .fontWeight(.regular)
                
                
            }
            .buttonStyle(NavigationButton())
        }
        
    }
    
    private func pointCloud(space: Space) -> some View {
        
                Image(uiImage: UIImage())
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding()
            
        
        
    }
    
 
    
    
    
}
