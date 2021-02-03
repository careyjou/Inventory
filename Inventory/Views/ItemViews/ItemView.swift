//
//  ItemView.swift
//  Inventory
//
//  Created by Vincent Spitale on 6/25/20.
//  Copyright © 2020 Vincent Spitale. All rights reserved.
//

import SwiftUI
import ARKit

struct ItemView: View {
    @EnvironmentObject var viewModel: InventoryViewModel
    @State private var itemSearch = ""
    @State private var isShowingPositionFreeAddItemView: Bool = false
    
    
    var body: some View {
        ZStack{
            ScrollView{
                VStack{
                    SearchBar(text: $itemSearch, label: "Search Items")
                        .frame(maxWidth: 700)
                        .padding(.horizontal)
                        .padding(.top, 5)
                    

                    
                    ItemList(itemSearch: $itemSearch)
                        .frame(maxWidth: 700)
                        .padding(.horizontal, 5)
                        .zIndex(1)
                    
                    
                }
                .sheet(isPresented: $isShowingPositionFreeAddItemView) {
                    PositionFreeAddItemView()
                }
            }
 
        
            VStack{
                Spacer()
                HStack{
                    Spacer()
                    
                    Button(action: { ARWorldTrackingConfiguration.supportsFrameSemantics(.sceneDepth) ? viewModel.showGeneralView() : (self.isShowingPositionFreeAddItemView = true)}) {
                            Image(systemName: "plus")
                        }
                        .buttonStyle(CircleButton())
                        .contextMenu{
                            Button(action: {self.isShowingPositionFreeAddItemView = true}) {
                                    Label("Create Item Without Position", systemImage: "location.slash.fill")
                                }
                            #if !(targetEnvironment(macCatalyst) || targetEnvironment(simulator))
                            if ARWorldTrackingConfiguration.supportsFrameSemantics(.sceneDepth) {
                                Button(action: {viewModel.showGeneralView()}) {
                                    Label("Create Item in AR", systemImage: "arkit")
                                }
                            }
                            #endif
                        }
                    
                }
                
            }

        }
        .navigationBarTitle(Text("Items"))
    }
}


struct ItemView_Previews: PreviewProvider {
    static var previews: some View {
        ItemView().environmentObject(InventoryViewModel())
    }
}
