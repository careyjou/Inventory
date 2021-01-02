//
//  SpaceView.swift
//  Inventory
//
//  Created by Vincent Spitale on 6/25/20.
//  Copyright © 2020 Vincent Spitale. All rights reserved.
//

import SwiftUI
import ARKit

struct SpaceView: View {
    @EnvironmentObject var controller: InventoryController
    @State private var spaceSearch = ""
    
    var body: some View {
        ZStack{
            ScrollView{
                VStack{
                    SearchBar(text: $spaceSearch, label: "Search Spaces")
                        .frame(maxWidth: 700)
                        .padding(.horizontal)
                        .padding(.top, 5)
                    
                    
                    SpaceList(spaceSearch: $spaceSearch)
                    .frame(maxWidth: 700)
                    .zIndex(1)
                    
                }
            }

            VStack{
                Spacer()
                HStack{
                    Spacer()
                    // non-LiDAR devices cannot map spaces
                    #if !(targetEnvironment(macCatalyst) || targetEnvironment(simulator))
                    if ARWorldTrackingConfiguration.supportsFrameSemantics(.sceneDepth) {
                    Button(action: {
                            controller.showMapSpaceView()
                        
                    }) {
                        Image(systemName: "plus")
                    }
                    .buttonStyle(CircleButton())
                    }
                    #endif
                    
                }
                
            }
        }
        .navigationBarTitle(Text("Spaces"))

    }
}

