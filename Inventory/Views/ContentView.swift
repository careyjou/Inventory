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
                .sheet(isPresented: $controller.isShowingAddItemView) {
                        AddItemView()
                    }
                .sheet(isPresented: $controller.isShowingAddSpaceView) {
                        AddSpaceView()
                    }
                .disabled(controller.isShowingAR)
            
                
                
        
            
            #if !(targetEnvironment(macCatalyst) || targetEnvironment(simulator))
            if (controller.isShowingAR) {
                ZStack{
                    self.arViewOverlay()
                    VStack{
                        HStack{
                            Spacer()
                            Button(action: {controller.AROff()}) {
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
            #endif
            
            
        }
        .accentColor(Color(.gray))
        .resignKeyboardOnDragGesture()
        
        
        
        
    }
    
    
    private func updateSpacePointClouds() {
        let data = (UIApplication.shared.delegate as! AppDelegate).data
        
        for space in spaces {
            DispatchQueue.global(qos: .userInitiated).async {
                data.addCloud(space: space)
            }
            
        }
        
    }
    

    
    
    
    
    #if !(targetEnvironment(macCatalyst) || targetEnvironment(simulator))
    private func arViewOverlay() -> some View {
        let arView = ARViewWrapper(controller: controller)
        let fullscreenArView = arView.edgesIgnoringSafeArea(.all).onDisappear(perform: {controller.resetAR()})
        
        
        return  ZStack {
            if (controller.arViewMode != .mapSpace) {
            fullscreenArView
                if (controller.arHasSpace && controller.arViewMode != .findItem) {
                    VStack{
                        Spacer()
                        Button(action: {controller.arButton()}) {
                            Text(controller.arViewMode.buttonText())
                        }
                        .buttonStyle(LargeTransparentRoundedButton(isSelected: true))
                        .padding()
                    }
                    .transition(.opacity)
                }
            }
            else {
                ARCaptureWrapper(controller: controller)
                    .edgesIgnoringSafeArea(.all)
                VStack{
                    Spacer()
                    Button(action: {controller.arButton()}) {
                        Text("Save Space")
                    }
                    .buttonStyle(LargeTransparentRoundedButton(isSelected: true))
                    .padding()
                }
            }
            
            
        }
    }

    
    
    

    
    #endif
    

    
    
    
    
    
}
