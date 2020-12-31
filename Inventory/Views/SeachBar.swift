//
//  SeachBar.swift
//  Inventory
//
//  Created by Vincent Spitale on 6/6/20.
//  Copyright © 2020 Vincent Spitale. All rights reserved.
//

import SwiftUI


struct SearchBar: View {
    @Binding var text: String
    
    @State private var isEditing = false
    @State var label: String = "Search"
    
    var body: some View {
        HStack {
            
            HStack{
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.secondary)
                    .padding(.leading, 8)
                    .padding(.vertical, 10)
                
                TextField(self.label, text: $text)
                    .onTapGesture {
                        withAnimation{self.isEditing = true}
                    }
                

                if (!text.isEmpty) {
                    Button(action: {
                        self.text = ""
                        
                    }) {
                        Image(systemName: "multiply.circle.fill")
                            .foregroundColor(.gray)
                            .padding(.trailing, 8)
                    }
                }
                
            }.background(Color(.systemGray5).opacity(0.6))
                .cornerRadius(10)
            
            
            
            if (isEditing || !text.isEmpty) {
                Button(action: {
                    self.text = ""
                    withAnimation {self.isEditing = false}
                    
                    
                    // Dismiss the keyboard
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }) {
                    Text("Cancel")
                        .foregroundColor(.secondary)
                }
                .transition(.move(edge: .trailing))
                .animation(.default)
            }
        }
    }
}

