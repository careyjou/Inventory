//
//  SpaceList.swift
//  Inventory
//
//  Created by Vincent Spitale on 6/24/20.
//  Copyright © 2020 Vincent Spitale. All rights reserved.
//

import SwiftUI
import ARKit

struct SpaceList: View {
    @FetchRequest(entity: Space.entity(), sortDescriptors: []) var spaces: FetchedResults<Space>
    @Binding var spaceSearch: String
    
    var body: some View {
        
        let sortedSpaces = spaces.sorted(by: {$0.getMostRecentMovedDate() > $1.getMostRecentMovedDate()})
        
        return  LazyVStack {
            ForEach(sortedSpaces.filter {
                self.spaceSearch.isEmpty ? true : ($0.name?.localizedCaseInsensitiveContains(self.spaceSearch) ?? false)
                
            }, id: \.self) { space in
                
                VStack{
                    NavigationLink(destination: SpaceDetail(space: space)) {
                SpacePreview(space: space)
            }
                    .buttonStyle(NavigationButton(isRounded: false))
                }
        }
        }
    }
    

    
}

