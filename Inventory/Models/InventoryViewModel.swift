//
//  InventoryViewModel.swift
//  Inventory
//
//  Created by Vincent Spitale on 6/24/20.
//  Copyright © 2020 Vincent Spitale. All rights reserved.
//

import SwiftUI
import Foundation

#if !targetEnvironment(macCatalyst)
import ARKit
#endif

class InventoryViewModel: ObservableObject {
    @Published public var isShowingSheet: Bool = false
    @Published public var arSheetMode: ARSheet = .addItemView
    @Published public var space: Space? = nil
    @Published public var arViewMode: ARViewMode = .none
    @Published public var arLocalizationStatus: LocalizationStatus = .capturing
    @Published public var finding: Findable? = nil
    
    
    public var arHasSpace: Bool {return self.space != nil}
    
    private var itemToAdd: Item?
    
    
    private var itemPosition: simd_float3?
    
    #if !(targetEnvironment(macCatalyst) || targetEnvironment(simulator))
    
    public var arCoordinator: ARCoordinator?
    public var arCaptureCoordinator: ARCaptureCoordinator?
    
    #endif
    
    private var spaceFile: URL?
    private var pointCloud: [PointCloudVertex]?



    

    public func resetAR() {
        self.space = nil
        self.arLocalizationStatus = .capturing
        self.itemToAdd = nil
        self.finding = nil
    }
    
    /// <#Description#>
    public func AROff() {
        withAnimation {self.arViewMode = .none}
    }
    
    public func showGeneralView() {
        withAnimation{self.arViewMode = .general}
    }
    
    
    public func showMapSpaceView() {
        withAnimation{self.arViewMode = .mapSpace}
    }
    
    public func showReposition(instance: ItemInstance) {
        self.finding = instance
        withAnimation{self.arViewMode = .repositionInstance}
    }
  

    
    public func setLocalizationStatus(status: LocalizationStatus) {
        self.arLocalizationStatus = status
    }

    

    
    #if !(targetEnvironment(macCatalyst) || targetEnvironment(simulator))
    public func getSpace() -> Space? {
        return self.space
    }
    
    public func setSpace(space: Space) {
        self.space = space
    }
    
    public func placeItem() {
        self.itemPosition = self.arCoordinator?.getItemPosition()
        self.setSheet(mode: .addItemView)
    }
    
    public func showFind(finding: Findable) {
        self.finding = finding
        withAnimation{self.arViewMode = .findItem}
    }

    
    public func repositionInstance() {
        // Get new position
        self.itemPosition = self.arCoordinator?.getItemPosition()
        
        // Get new space
       
        
        
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
    
    public func getItemPosition() -> simd_float3? {
        return self.itemPosition
    }
    
    public func getPointCloud() -> [PointCloudVertex]? {
        return self.pointCloud
    }
    
    
}

enum ARSheet: Equatable {
    case addSpaceView
    case addItemView
    case itemSelector
}
