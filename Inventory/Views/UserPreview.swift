//
//  UserPreview.swift
//  Inventory
//
//  Created by Vincent Spitale on 6/26/20.
//  Copyright © 2020 Vincent Spitale. All rights reserved.
//

import SwiftUI

struct UserPreview: View {
    var body: some View {
        Image("User")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .clipShape(Circle())
            
    }
}

struct UserPreview_Previews: PreviewProvider {
    static var previews: some View {
        UserPreview()
    }
}
