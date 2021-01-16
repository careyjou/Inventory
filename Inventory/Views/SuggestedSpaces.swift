//
//  SuggestedSpaces.swift
//  Inventory
//
//  Created by Vincent Spitale on 6/26/20.
//  Copyright © 2020 Vincent Spitale. All rights reserved.
//

import SwiftUI

struct SuggestedSpaces: View {
    @FetchRequest(entity: Space.entity(), sortDescriptors: []) var spaces: FetchedResults<Space>
    @EnvironmentObject var controller: InventoryController
    
    var body: some View {
        let sortedSpaces = spaces.sorted(by: {$0.getMostRecentMovedDate() > $1.getMostRecentMovedDate()})
        
        let suggestedSpaces = sortedSpaces.prefix(4)
        
        return VStack{
            
            ForEach(suggestedSpaces, id: \.self) { space in
            
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

