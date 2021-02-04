//
//  ItemInstancePreview.swift
//  Inventory
//
//  Created by Vincent Spitale on 12/23/20.
//  Copyright © 2020 Vincent Spitale. All rights reserved.
//

import SwiftUI

struct ItemInstancePreview: View {
    @ObservedObject var instance: ItemInstance
    var isDetailed: Bool
    
    var body: some View {
        if let name = instance.item?.name {
            if isDetailed {
                HStack{
                    Text(name)
                        .font(.body)
                        .fontWeight(.regular)
                    Spacer()
                    if let spaceName = instance.getSpace()?.getName() {
                        HStack{
                        Text(Image(systemName: "chevron.right")).foregroundColor(.secondary)
                        Text(spaceName)
                            .font(.body)
                            .foregroundColor(.secondary)
                        }
                    }
                    
                }
            }
            else {
        Text(name)
            .font(.body)
            .fontWeight(.regular)
        }
        }
    }
}

