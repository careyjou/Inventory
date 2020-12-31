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
    @ObservedObject var data: AppData
    @State var isShowingItemSheet: Bool = false
    @State var itemSelection: ItemInstance? = nil
    
    var body: some View {
        
        
        return self.model(data: data)
    }
    
    @ViewBuilder private func model(data: AppData) -> some View {
    

        if (data.getPointCloud(space: space) != nil) {
            ZStack{
                GeometryReader { geometry in
            PointCloudView(space: space, data: data).aspectRatio(contentMode: .fill).edgesIgnoringSafeArea(.all)
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
            }
                        .sheet(isPresented: $isShowingItemSheet) {
                            SpaceItemList(space: space, selection: $itemSelection)
                        }
                    
                }
            
        
        
    }
    

    
    
}


