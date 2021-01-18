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
    @EnvironmentObject var viewModel: InventoryViewModel
    @FetchRequest(entity: Space.entity(), sortDescriptors: []) var spaces: FetchedResults<Space>
    
    var body: some View {
        self.updateSpacePointClouds()
        
        return ZStack {
            InventoryNavigation()
                .zIndex(0)
                .sheet(isPresented: $viewModel.isShowingSheet) {
                    switch viewModel.arSheetMode {
                    case .addItemView:
                        AddItemView()
                    case .addSpaceView:
                        AddSpaceView()
                    case .itemSelector:
                        #if !(targetEnvironment(macCatalyst) || targetEnvironment(simulator))
                    if let space = viewModel.getSpace() {
                        SpaceItemList(space: space, selection: $viewModel.finding)
                    }
                        #endif
                    }
                }
                .disabled(self.viewModel.arViewMode != .none && (self.viewModel.arSheetMode != .addItemView) && self.viewModel.arSheetMode != .itemSelector)
            
            
            
            
            if (self.viewModel.arViewMode != .none) {
                ZStack{
                    self.arViewOverlay()
                    VStack{
                        HStack{
                            Spacer()
                            Button(action: {self.viewModel.AROff()}) {
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
                if (self.viewModel.arHasSpace) {
                ZStack{
                HStack{
                    #if !(targetEnvironment(macCatalyst) || targetEnvironment(simulator))
                    if (self.viewModel.arViewMode == .general) {
                        
                        Button(action: {self.viewModel.placeItem()}) {
                            Text("Place Item")
                        }
                        .buttonStyle(LargeTransparentRoundedButton(isSelected: true))
                    }
                    
                    if (self.viewModel.arViewMode == .repositionInstance) {
                        Button(action: {self.viewModel.repositionInstance()}) {
                            Text("Reposition Item")
                        }
                        .buttonStyle(LargeTransparentRoundedButton(isSelected: true))
                    }
                    #endif
                    
                    
                
                }
                    HStack{
                    VStack{
                        Group{
                            if (self.viewModel.arViewMode != .general) {
                                Button(action: {self.viewModel.arViewMode = .general}) {
                                    Image(systemName: "chevron.left")
                                }
                                .buttonStyle(SecondaryCircleButton())
                                .padding(.top)
                            }
                            if (self.viewModel.arViewMode == .general || self.viewModel.arViewMode == .findItem) {
                                Button(action: {self.viewModel.setSheet(mode: .itemSelector)}) {
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
            if (self.viewModel.arViewMode != .mapSpace) {
                #if !(targetEnvironment(macCatalyst) || targetEnvironment(simulator))
                ARViewWrapper(viewModel: self.viewModel).edgesIgnoringSafeArea(.all).onDisappear(perform: {self.viewModel.resetAR()})
                #endif
                VStack{
                    HStack{
                        if (!self.viewModel.arHasSpace) {
                        Spacer()
                        }
                        Group{
                            if (self.viewModel.arHasSpace) {
                                #if !(targetEnvironment(macCatalyst) || targetEnvironment(simulator))
                                if (self.viewModel.arViewMode == .findItem) {
                                    HStack {
                                        Text(self.viewModel.getSpace()?.getName() ?? "Space")
                                        if let finding = self.viewModel.finding {
                                        Text(Image(systemName: "chevron.right")).foregroundColor(.secondary)
                                            Text(finding.getName() ?? "Item")
                                        }
                                    }
                                }
                                else {
                                Text(self.viewModel.getSpace()?.getName() ?? "Space")
                                }
                                #endif
                            }
                            else {
                                Text(self.viewModel.arLocalizationStatus.statusText())
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
                ARCaptureWrapper(viewModel: self.viewModel)
                    .edgesIgnoringSafeArea(.all)
                    .onDisappear(perform: {self.viewModel.resetAR()})
                
                VStack{
                    Spacer()
                    Button(action: {self.viewModel.saveSpace()}) {
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
