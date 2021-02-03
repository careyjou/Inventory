//
//  SpacePreview.swift
//  Inventory
//
//  Created by Vincent Spitale on 6/16/20.
//  Copyright © 2020 Vincent Spitale. All rights reserved.
//

import SwiftUI

struct SpacePreview: View {
    
    @ObservedObject public var space: Space
    
    var body: some View {
        
        
        return
            VStack{
            HStack{
            VStack(alignment: .leading){
                HStack{
            if let name = space.name {
            Text(name)
                .bold()
                .foregroundColor(.primary)
                .padding(.trailing, 5)
            }
                    Spacer()
                }
                Spacer()
                HStack {
                    Text(String(space.getAllItemInstances().count) + " " + Utils.singularPluralLanguage(int: space.getAllItemInstances().count, singular: "item", plural: "items")).foregroundColor(Color.gray)
                    Spacer()
                }
                
            }.padding(.leading, 5)
            
            Spacer()
        }
            }
        
        
    }
    
    
}



