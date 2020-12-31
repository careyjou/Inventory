//
//  ContentPreviewView.swift
//  Inventory
//
//  Created by Vincent Spitale on 8/23/20.
//  Copyright © 2020 Vincent Spitale. All rights reserved.
//

import SwiftUI

protocol DetailView: View {
    associatedtype V: View
    
    func options() -> V
    func content() -> V
    func overlay() -> V
    func name() -> String
}

extension DetailView {
    func combined() -> some View {
        ZStack{
            ScrollView(.vertical) {
                VStack {
                    self.options().frame(maxWidth: 700).padding(.top, 10)
                    self.content().frame(maxWidth: 700)
                    HStack{
                        Spacer()
                    }
                }
            }
            self.overlay()
        }
        .navigationBarTitle(Text(self.name()))
            
        
        }
    
}
