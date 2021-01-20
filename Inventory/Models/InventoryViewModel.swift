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


/// Represents the state of the app's augmented reality properties. Inventory
/// largely follows the MVVM design pattern. The ViewAR view controller
/// dynamically reacts to changes in the published properties using Combine
/// to ensure consistent information with the rest of the app. SwiftUI views in the main
/// ContextView also update with changes to this state object that is stored in the environment.
class InventoryViewModel: ObservableObject {
    // controls if the swiftui sheet is presented
    @Published public var isShowingSheet: Bool = false
    // determines what type of sheet is presented
    @Published public var arSheetMode: ARSheet = .addItemView
    // the space that has been detected by the camera pose localizer
    @Published public var space: Space? = nil
    // the ar mode that enables certain ui elements to be shown
    @Published public var arViewMode: ARViewMode = .none
    // informs the user about the status of the localization
    @Published public var arLocalizationStatus: LocalizationStatus = .capturing
    // the findable object that the ar view will display in the scene
    @Published public var finding: Findable? = nil
    
    // unlocks ui elements once the arView has been localized
    public var arHasSpace: Bool {return self.space != nil}
    
    // the item that an instance will inherit from in the addInstance mode
    private var itemToAdd: Item?
    
    // the position of the item instance to be added to the space
    private var itemPosition: simd_float3?
    
    #if !(targetEnvironment(macCatalyst) || targetEnvironment(simulator))
    
    // the delegate of the ar view controller
    public var arCoordinator: ARCoordinator?
    // the delegate of the point cloud capture view controller
    public var arCaptureCoordinator: ARCaptureCoordinator?
    
    #endif
    // the point cloud collected in the 'mapSpace' ar view mode
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
