//
//  OptionsView.swift
//  Inventory
//
//  Created by Vincent Spitale on 6/15/20.
//  Copyright © 2020 Vincent Spitale. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
    
    var body: some View {
        ScrollView{
                VStack{
                    Button(action: {}) {
                        Label{
                            Text("User Guide")
                        } icon: {
                            Image(systemName: "book.fill")
                            .foregroundColor(.gray)
                        }
                    }
                    .buttonStyle(NavigationButton())
                    NavigationLink(destination: AboutView()) {
                        Label{
                            Text("About inventory")
                        } icon: {
                            Image(systemName: "info.circle.fill")
                            .foregroundColor(.gray)
                        }
                        }
                    .buttonStyle(NavigationButton())
                    
                }
                .padding(.horizontal)
                .frame(maxWidth: 700)
        
        }
        
        .navigationBarTitle("Settings")
            
    
    
    }
    
}

struct OptionsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
