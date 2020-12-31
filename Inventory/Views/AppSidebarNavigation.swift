//
//  AppSidebarNavigation.swift
//  Inventory
//
//  Created by Vincent Spitale on 6/24/20.
//  Copyright © 2020 Vincent Spitale. All rights reserved.
//

import SwiftUI

struct InventoryNavigation: View {
    #if os(iOS)
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    #endif
    @State private var itemSearch = ""
    @ObservedObject var controller: InventoryState
    @State private var selection: Set<NavigationViewMode> = [.item]
    
    
    @ViewBuilder var content: some View {
        SearchBar(text: $itemSearch)
        
        if (itemSearch.isEmpty) {
        
        NavigationLink(destination: ItemView(controller: controller)) {
            if (horizontalSizeClass == .compact) {
            HStack{
                Image(systemName: "circle.fill")
                    .foregroundColor(.gray)
                Text("Items")
            }
            }
            else {
                Label("Items" , systemImage: "circle.fill")
            }
        }
        .buttonStyle(NavigationButton())
        .accessibility(label: Text("Items"))
        
        NavigationLink(destination: SpaceView(controller: controller)) {
            if (horizontalSizeClass == .compact) {
            HStack{
                Image(systemName: "rectangle.portrait.fill")
                    .foregroundColor(.gray)
                Text("Spaces")
            }
            }
            else {
                Label("Spaces" , systemImage: "rectangle.portrait.fill")
            }
        }
        .buttonStyle(NavigationButton())
        .accessibility(label: Text("Spaces"))
        }
        
        else {
            ItemList(itemSearch: $itemSearch)
        }
    }
    
    var sideBar: some View {
        List() {
            content
        }
            .listStyle(SidebarListStyle())
        
    }
    
    
    @ViewBuilder var nav: some View {
        if (horizontalSizeClass == .compact) {
            ScrollView {
                VStack(alignment: .leading){
                    content.padding(.horizontal)
                }
            }
        }
        else {
            sideBar
        }
        
    }
    
    var body: some View {
        
    
        NavigationView {
            nav
                .navigationBarTitle(Text("Inventory"))
            ItemView(controller: controller)
            }
        .accentColor(Color(.gray))
        .resignKeyboardOnDragGesture()
        
    }
    
}

extension UIApplication {
    func endEditing(_ force: Bool) {
        self.windows
            .filter{$0.isKeyWindow}
            .first?
            .endEditing(force)
    }
}

struct ResignKeyboardOnDragGesture: ViewModifier {
    var gesture = DragGesture().onChanged{_ in
        UIApplication.shared.endEditing(true)
    }
    func body(content: Content) -> some View {
        content.gesture(gesture)
    }
}

extension View {
    func resignKeyboardOnDragGesture() -> some View {
        return modifier(ResignKeyboardOnDragGesture())
    }
}


