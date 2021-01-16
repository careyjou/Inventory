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
    @Published public var isShowingSheet: Bool = false
    @Published public var arSheetMode: ARSheet = .addItemView
    @Published public var arHasSpace: Bool = false
    @Published public var arViewMode: ARViewMode = .none
    @Published public var arLocalizationStatus: LocalizationStatus = .capturing
    @Published public var itemListSelection: ItemInstance? = nil
    
    public var spaceToAdd: String? = nil
    
    
    public var itemPosition: simd_float3?
    
    

    public var selectedItem: Item? = nil
    public var spaceFile: URL?
    public var pointCloud: [PointCloudVertex]?
    #if !(targetEnvironment(macCatalyst) || targetEnvironment(simulator))
    
    public var arCoordinator: ARCoordinator?
    public var arCaptureCoordinator: ARCaptureCoordinator?
    
    #endif

    
    
    

    public func resetAR() {
        self.arHasSpace = false;
        
        #if !(targetEnvironment(macCatalyst) || targetEnvironment(simulator))
        self.arCoordinator = nil
        self.arCaptureCoordinator = nil
        #endif
        self.arLocalizationStatus = .capturing
        self.arSheetMode = .addItemView
    }
    
    /// <#Description#>
    public func AROff() {
        withAnimation {self.arViewMode = .none}
    }
    
    public func showGeneralView() {
        withAnimation{self.arViewMode = .general}
    }
    
    /// <#Description#>
    public func showAddItemView() {
        
        withAnimation{self.arViewMode = .addItem}
        
        
    }
    
    public func showMapSpaceView() {
        withAnimation{self.arViewMode = .mapSpace}
    }
    
    public func showReposition() {
        withAnimation{self.arViewMode = .repositionInstance}
    }
    
    public func showFind() {
        withAnimation{self.arViewMode = .findItem}
    }
    
    public func hasSpace() {
        withAnimation{self.arHasSpace = true}
    }
    
    public func setLocalizationStatus(status: LocalizationStatus) {
        self.arLocalizationStatus = status
    }

    
    #if !(targetEnvironment(macCatalyst) || targetEnvironment(simulator))
    public func getSpace() -> Space? {
        self.arCoordinator?.getSpace()
    }
    
    public func placeItem() {
        self.itemPosition = self.arCoordinator?.getItemPosition()
        self.setSheet(mode: .addItemView)
    }
    
  
    
    public func repositionInstance() {
        // Get new position
        self.itemPosition = self.arCoordinator?.getItemPosition()
        
        // Get new space
        let space = self.arCoordinator?.getSpace()
        
        
        //Add item to new space
        
        
        // End AR
        self.AROff()
    
    }
    
    private func setPointCloud() {
        let coordinator = self.arCaptureCoordinator
        let points = coordinator?.getPoints()
        self.pointCloud = points
        
        
    }
    
   
    
    public func saveSpace() {
        self.setPointCloud()
        self.AROff()
        self.setSheet(mode: .addSpaceView)
    }
   
    #endif

  
    public func setSheet(mode: ARSheet) {
        self.arSheetMode = mode
        self.isShowingSheet = true
    }
    
    
}

enum ARSheet: Equatable {
    case addSpaceView
    case addItemView
    case itemSelector
}
