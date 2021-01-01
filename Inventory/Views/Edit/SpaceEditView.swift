//
//  SpaceEditView.swift
//  Inventory
//
//  Created by Vincent Spitale on 5/17/20.
//  Copyright © 2020 Vincent Spitale. All rights reserved.
//

import SwiftUI
import Combine
import CoreData

struct SpaceEditView: View {
    @Environment(\.managedObjectContext) var moc
    @ObservedObject var space: Space
    @Binding var isShowingEditView: Bool
    @State private var newName: String = ""
    
    var body: some View {
        return NavigationView{
            ScrollView{
                VStack(){
                    HStack{
                        Text("Name")
                            .bold()
                        TextField("Name", text:$newName)
                            .multilineTextAlignment(.trailing)
                    }
                    
                }
                .padding()
            }
            .navigationBarTitle(Text("Edit Space"), displayMode: .inline)
            .navigationBarItems(leading:
                                    HStack{
                                        Button(action: {self.$isShowingEditView.wrappedValue.toggle()}) {
                    Image(systemName: "xmark")
                }
                .buttonStyle(SecondaryCircleButton())
                                Button(action: {self.delete()}) {
                                    Image(systemName: "trash")
                                        .foregroundColor(.red)
                                }
                                .buttonStyle(SecondaryCircleButton())
                                
                            },
                                trailing:
                Button(action: { self.updateSpace()}) {
                    Image(systemName: "checkmark")
                }
                .buttonStyle(SecondaryCircleButton()))
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear {
            self.initdata()
        }
    }
    
    
    func initdata() {
        self.newName = space.getName() ?? ""
    }
    
    
    func updateSpace() {
        
        _ = space.setName(newName: self.newName)
        try? moc.save()
        
        self.$isShowingEditView.wrappedValue.toggle()
    }
    
    func delete() {
        moc.delete(space)
        try? moc.save()
        self.$isShowingEditView.wrappedValue.toggle()
    }
    

    
    
}


