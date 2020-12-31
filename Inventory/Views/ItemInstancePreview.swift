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
    
    var body: some View {
        if let name = instance.item?.name {
        Text(name)
            .font(.body)
            .fontWeight(.regular)
        }
    }
}

