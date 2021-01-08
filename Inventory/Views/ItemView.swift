//
//  ItemView.swift
//  Inventory
//
//  Created by Vincent Spitale on 6/25/20.
//  Copyright © 2020 Vincent Spitale. All rights reserved.
//

import SwiftUI

struct ItemView: View {
    @EnvironmentObject var controller: InventoryController
    @State private var itemSearch = ""
    
    
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
            }
 
        
            VStack{
                Spacer()
                HStack{
                    Spacer()
                    Menu{
                        Button(action: {}) {
                            Label("Create Item Without Position", systemImage: "location.slash.fill")
                        }
                    #if !(targetEnvironment(macCatalyst) || targetEnvironment(simulator))
                        Button(action: {controller.showAddItemView()}) {
                            Label("Create Item in AR", systemImage: "arkit")
                        }
                    #endif
                    } label: {
                        Button(action: {}) {
                            Image(systemName: "plus")
                        }
                        .buttonStyle(CircleButton())
                    }
                }
                
            }

        }
        .navigationBarTitle(Text("Items"))
    }
}


struct ItemView_Previews: PreviewProvider {
    static var previews: some View {
        ItemView()
    }
}
