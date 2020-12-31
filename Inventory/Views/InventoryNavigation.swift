//
//  InventoryNavigation.swift
//  Inventory
//
//  Created by Vincent Spitale on 6/24/20.
//  Copyright © 2020 Vincent Spitale. All rights reserved.
//

import SwiftUI
import ARKit

struct InventoryNavigation: View {
    #if os(iOS)
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @FetchRequest(entity: ItemInstance.entity(), sortDescriptors: []) var itemInstances: FetchedResults<ItemInstance>
    @FetchRequest(entity: Space.entity(), sortDescriptors: []) var spaces: FetchedResults<Space>
    #endif
    @EnvironmentObject var controller: InventoryController
    @State private var itemSearch = ""
    @Environment(\.colorScheme) var colorScheme
    
    
    @ViewBuilder var content: some View {
        
        SearchBar(text: $itemSearch, label: "Search inventory")
            .padding(.top, 5)
        
        if (itemSearch.isEmpty) {
        
            NavigationLink(destination: ItemView()) {
                Label {
                    Text("Items")
                } icon: {
                    Image(systemName: "circlebadge.fill")
                        .foregroundColor(.gray)
                }
                
            
        }
        .buttonStyle(NavigationButton())
        .accessibility(label: Text("Items"))
        
            NavigationLink(destination: SpaceView()) {
                Label("Spaces" , image: "spaces")
            
        }
        .buttonStyle(NavigationButton())
        .accessibility(label: Text("Spaces"))
        }
        
        else {
            ItemList(itemSearch: $itemSearch)
        }
    }
    
    
    @ViewBuilder var nav: some View {
        
        
        
            ZStack{
            ScrollView {
                VStack(alignment: .leading){
                    
                    
                    
                    content.padding(.horizontal)
                    
                    if (itemSearch.isEmpty) {
                        if (!itemInstances.isEmpty) {
                        
                        Divider()
                            .hidden()
                    Text("Suggested Items")
                            .font(.title3)
                            .bold()
                            .padding(.horizontal)
                            .padding(.vertical)
                        
                            SuggestedItemsList()
                                .padding(.horizontal)
                        }
                        
                        if (!spaces.isEmpty) {
                            
                        Divider()
                            .hidden()
                        
                    Text("Suggested Spaces")
                        .font(.title3)
                        .bold()
                        .padding(.horizontal)
                        .padding(.top)
                            
                    
                    SuggestedSpaces()
                    }
                    }
                    
                    
                }
            }
                VStack{
                    Spacer()
                    HStack{
                        Spacer()
                        #if !(targetEnvironment(macCatalyst) || targetEnvironment(simulator))
                        if ARWorldTrackingConfiguration.supportsFrameSemantics(.sceneDepth) {
                        Button(action: {controller.showGeneralView()}) {
                                Image(systemName: "arkit")
                                    .font(.title)
                                    .accessibility(label: Text("AR View"))
                                
                        }
                        .buttonStyle(CircleButton())
                        }
                        #endif
                        
                    }
                    
                }
                
            }
        
        
    }
    
    var body: some View {
        
    
        NavigationView {
            
            nav
                .navigationTitle(Text("inventory"))
                .navigationBarItems(trailing: NavigationLink(destination: SettingsView()) {
                    Image(systemName: "gearshape")
                        .font(.title2)
                        .foregroundColor(.gray)
                }
                .buttonStyle(ScalingOpacityButton()))
            
            if (horizontalSizeClass != .compact) {
                ItemView()
            }
            }
    }
        
    
    

    
}




