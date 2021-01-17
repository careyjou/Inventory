//Inventory Workspace Group
//  ContentView.swift
//  Inventory
//
//  Created by Vincent Spitale on 12/6/19.
//  Copyright © 2019 Vincent Spitale. All rights reserved.
//

import SwiftUI
import Combine
import RealityKit
import Foundation

#if !targetEnvironment(macCatalyst)
import ARKit
#endif


struct ContentView: View {
    @Environment(\.managedObjectContext) var moc
    @EnvironmentObject var controller: InventoryController
    @FetchRequest(entity: Space.entity(), sortDescriptors: []) var spaces: FetchedResults<Space>
    
    var body: some View {
        self.updateSpacePointClouds()
        
        return ZStack {
            InventoryNavigation()
                .zIndex(0)
                .sheet(isPresented: $controller.isShowingSheet) {
                    switch controller.arSheetMode {
                    case .addItemView:
                        AddItemView()
                    case .addSpaceView:
                        AddSpaceView()
                    case .itemSelector:
                        #if !(targetEnvironment(macCatalyst) || targetEnvironment(simulator))
                    if let space = controller.getSpace() {
                        SpaceItemList(space: space, selection: $controller.finding)
                    }
                        #endif
                    }
                }
                .disabled(self.controller.arViewMode != .none && (self.controller.arSheetMode != .addItemView) && self.controller.arSheetMode != .itemSelector)
            
            
            
            
            if (self.controller.arViewMode != .none) {
                ZStack{
                    self.arViewOverlay()
                    VStack{
                        HStack{
                            Spacer()
                            Button(action: {self.controller.AROff()}) {
                                Image(systemName: "xmark")
                            }
                            .buttonStyle(SecondaryCircleButton())
                            .padding()
                        }
                        Spacer()
                    }
                }
                .transition(.opacity)
                .zIndex(2)
                
            }
            
            
        }
        .accentColor(Color(.gray))
        .resignKeyboardOnDragGesture()
        
        
        
        
    }
    
    
    private func updateSpacePointClouds() {
        guard let data = (UIApplication.shared.delegate as? AppDelegate)?.data else {
            return
        }
        
        for space in spaces {
            DispatchQueue.global(qos: .userInitiated).async {
                data.addCloud(space: space)
            }
            
        }
        
    }
    
    
    
    private func arButtons() -> some View {
        return VStack(alignment: .center) {
            Spacer()
            Group{
                if (self.controller.arHasSpace) {
                ZStack{
                HStack{
                    #if !(targetEnvironment(macCatalyst) || targetEnvironment(simulator))
                    if (self.controller.arViewMode == .general || self.controller.arViewMode == .addItem) {
                        
                        Button(action: {self.controller.placeItem()}) {
                            Text("Place Item")
                        }
                        .buttonStyle(LargeTransparentRoundedButton(isSelected: true))
                    }
                    
                    if (self.controller.arViewMode == .repositionInstance) {
                        Button(action: {self.controller.repositionInstance()}) {
                            Text("Reposition Item")
                        }
                        .buttonStyle(LargeTransparentRoundedButton(isSelected: true))
                    }
                    #endif
                    
                    
                
                }
                    HStack{
                    VStack{
                        Group{
                            if (self.controller.arViewMode != .general) {
                                Button(action: {self.controller.arViewMode = .general}) {
                                    Image(systemName: "chevron.left")
                                }
                                .buttonStyle(SecondaryCircleButton())
                                .padding(.top)
                            }
                            if (self.controller.arViewMode == .general || self.controller.arViewMode == .findItem) {
                                Button(action: {self.controller.setSheet(mode: .itemSelector)}) {
                            Image(systemName: "magnifyingglass")
                        }
                        .buttonStyle(SecondaryCircleButton())
                        .padding(.top)
                    }
                        }
                    }
                        Spacer()
                    }
                    .padding()
                    
                    
                }
                }
            }
            
        }
    }
    
    private func arViewOverlay() -> some View {
        return  ZStack {
            if (self.controller.arViewMode != .mapSpace) {
                #if !(targetEnvironment(macCatalyst) || targetEnvironment(simulator))
                ARViewWrapper(controller: self.controller).edgesIgnoringSafeArea(.all).onDisappear(perform: {self.controller.resetAR()})
                #endif
                VStack{
                    HStack{
                        if (!self.controller.arHasSpace) {
                        Spacer()
                        }
                        Group{
                            if (self.controller.arHasSpace) {
                                #if !(targetEnvironment(macCatalyst) || targetEnvironment(simulator))
                                Text(self.controller.getSpace()?.getName() ?? "Space")
                                #endif
                            }
                            else {
                                Text(self.controller.arLocalizationStatus.statusText())
                            }
                        }
                        .padding(10)
                        .foregroundColor(.primary)
                        .background(ButtonMaterial(highContrast: false))
                        .contentShape(RoundedRectangle(cornerRadius: .greatestFiniteMagnitude))
                        .clipShape(RoundedRectangle(cornerRadius: .greatestFiniteMagnitude))
                        .padding()
                        Spacer()
                    }
                    Spacer()
                }
                arButtons()
            }
            else {
                #if !(targetEnvironment(macCatalyst) || targetEnvironment(simulator))
                ARCaptureWrapper(controller: self.controller)
                    .edgesIgnoringSafeArea(.all)
                    .onDisappear(perform: {self.controller.resetAR()})
                
                VStack{
                    Spacer()
                    Button(action: {self.controller.saveSpace()}) {
                        Text("Save Space")
                    }
                    .buttonStyle(LargeTransparentRoundedButton(isSelected: true))
                    .padding()
                }
                #endif
            }
            
            
        }
    }
    
  
    
   
    
    
    
    
    
    
    
    
    
    
    
}
