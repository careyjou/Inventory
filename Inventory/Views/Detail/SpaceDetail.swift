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
                        .padding(.top)
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
                    
                    if let data = (UIApplication.shared.delegate as? AppDelegate)?.data {
                    NavigationLink(destination: Space3D(space: space, data: data))
                    {
                        Image(systemName: "view.3d")
                    }.buttonStyle(CircleButton())
                    .contextMenu {
                        Button(action: { self.sharePointCloud()}) {
                            Label("Export Cloud", systemImage: "square.and.arrow.up")
                        }
                    }
                    }
                    
                
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
        
        items.sort(by: { ($0.getLastModified() ?? Date()) > ($1.getLastModified() ?? Date()) })
        return VStack{ForEach(items, id: \.self) { item in
            NavigationLink(destination: ItemInstanceDetail(instance: item)) {
                Text(item.getName() ?? "")
                    .font(.body)
                    .fontWeight(.regular)
                
                
            }
            .buttonStyle(NavigationButton())
        }
        }
        
    }
    
    private func pointCloud(space: Space) -> some View {
        
                Image(uiImage: UIImage())
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding()
            
        
        
    }
    
    private func sharePointCloud() {
        guard let data = (UIApplication.shared.delegate as? AppDelegate)?.data,
              let cloud = data.getPointCloud(space: space)
        else {
            return
        }
    
        let name = (space.getName() ?? "") + "_cloud"
        
        let file = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("\(name).ply")
        
        DispatchQueue.global(qos: .userInitiated).async {
            Utils.plyFileFromPoints(points: cloud.getPointCloud(), url: file)
            DispatchQueue.main.async {
                let activityView = UIActivityViewController(activityItems: [file], applicationActivities: nil)
                
                UIApplication.shared.windows.first?.rootViewController?.present(activityView, animated: true, completion: nil)
                
                
                if UIDevice.current.userInterfaceIdiom == .pad {
                    activityView.popoverPresentationController?.sourceView = UIApplication.shared.windows.first
                    activityView.popoverPresentationController?.sourceRect = CGRect(x: UIScreen.main.bounds.width, y: UIScreen.main.bounds.height, width: 200, height: 300)
                }
 
                
            }
            
        }
       
        
        
        
        
    }
    
 
    
    
    
}
