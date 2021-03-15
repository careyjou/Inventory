//
//  Space3D.swift
//  Inventory
//
//  Created by Vincent Spitale on 6/7/20.
//  Copyright © 2020 Vincent Spitale. All rights reserved.
//

import SwiftUI

struct Space3D: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var space: Space
    @State var isShowingItemSheet: Bool = false
    @State var itemSelection: Findable? = nil
    
    var body: some View {
        
        
        return self.model()
    }
    
    @ViewBuilder private func model() -> some View {
    
        
        
            ZStack{
                GeometryReader { geometry in
                    PointCloudView(space: space, findable: $itemSelection).aspectRatio(contentMode: .fill).edgesIgnoringSafeArea(.all)
                .frame(maxWidth: geometry.size.width, maxHeight: geometry.size.height)
                }
                VStack{
                    Spacer()
                    HStack{
                        Spacer()
                        Button(action: {isShowingItemSheet = true}) {
                            Label("Find Item", systemImage: "magnifyingglass")
                        }
                        .buttonStyle(LargeTransparentRoundedButton(isSelected: true))
                        .padding(.bottom)
                        Spacer()
                    }
                }
            
                        .sheet(isPresented: $isShowingItemSheet) {
                            SpaceItemList(space: space, selection: $itemSelection)
                        }
                    
            }.navigationBarItems(trailing:
                                    Group{
                                        if ((itemSelection as? ItemInstance) != nil) {
                                            HStack{
                                                Text(space.getName() ?? "Space" )
                                                Text(Image(systemName: "chevron.right")).foregroundColor(.secondary)
                                                Text(itemSelection?.getName() ?? "Item")
                                            }
                                        }
                                        else {
                                            Text(space.getName() ?? "Space")
                                        }
                                    }
                                    .font(.body)
                                )
            
            
        
        
        
    }

    

    
    
}


