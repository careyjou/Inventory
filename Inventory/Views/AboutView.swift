//
//  AboutView.swift
//  Inventory
//
//  Created by Vincent Spitale on 7/19/20.
//  Copyright © 2020 Vincent Spitale. All rights reserved.
//

import SwiftUI

struct AboutView: View {
    var body: some View {
        ScrollView {
            VStack{
        VStack(alignment: .leading){
            Image("inventoryLogoLarge")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: 300)
                .padding()
            Text("Inventory is developed by Vincent Spitale, a student studying computer science and mathematics at Northeastern University.")
                .padding()
            Spacer()
            
        }
        .frame(maxWidth: 700)
                HStack{
                    Spacer()
                }
            }
    }
    }
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
    }
}
