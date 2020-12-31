//
//  InventoryController.swift
//  Inventory
//
//  Created by Vincent Spitale on 6/24/20.
//  Copyright © 2020 Vincent Spitale. All rights reserved.
//

import SwiftUI
import CoreData
import RealityKit
import Foundation
import SceneKit

#if !targetEnvironment(macCatalyst)
import ARKit
#endif

class InventoryController: ObservableObject {
    @Published public var isShowingAR: Bool = false
    @Published public var isShowingAddItemView: Bool = false
    @Published public var isShowingAddSpaceView: Bool = false
    @Published public var arHasSpace: Bool = false
    
    
    public var spaceToAdd: String? = nil
    
    
    public var itemPosition: simd_float3?
    
    
    public var arViewMode: ARViewMode = .general
    public var selectedItem: Item? = nil
    public var spaceFile: URL?
    public var pointCloud: [PointCloudVertex]?
    #if !(targetEnvironment(macCatalyst) || targetEnvironment(simulator))
    
    public var arCoordinator: ARCoordinator?
    public var arCaptureCoordinator: ARCaptureCoordinator?
    
   
    
    
    
    

    public func resetAR() {
        self.arHasSpace = false;
        self.arCoordinator = nil
    }
    
    public func arButton() {
        if (self.arViewMode == .addItem) {
            self.itemPosition = self.arCoordinator!.getItemPosition()
            self.isShowingAddItemView = true;
        }
        else if (self.arViewMode == .repositionInstance) {
            // Get new position
            self.itemPosition = self.arCoordinator!.getItemPosition()
            
            // Get new space
            let space = self.arCoordinator?.getSpace()
            
            
            //Add item to new space
            
            
            // End AR
            self.AROff()
            
            
        }
        else if (self.arViewMode == .mapSpace) {
            self.setPointCloud()
            self.AROff()
            self.isShowingAddSpaceView = true
        }
    }
    
    public func showGeneralView() {
        self.arViewMode = .general
        self.AROn()
    }
    
    /// <#Description#>
    public func showAddItemView() {
        
        self.arViewMode = .addItem
        self.AROn()
        
        
    }
    
    public func showMapSpaceView() {
        self.arViewMode = .mapSpace
        self.AROn()
    }
    

    
    /// <#Description#>
    private func AROn() {
        withAnimation {self.isShowingAR = true}
    }
    
    /// <#Description#>
    public func AROff() {
        withAnimation {self.isShowingAR = false}
    }

    private func setPointCloud() {
        let coordinator = self.arCaptureCoordinator
        let points = coordinator?.getPoints()
        self.pointCloud = points
        
        
    }
    #endif

    
    
}

