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
    
    // the item instance that is getting a new position in the reposition mode
    private var repositioning: ItemInstance?
    
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



    
    /// Sets ar state to default values.
    public func resetAR() {
        self.space = nil
        self.arLocalizationStatus = .capturing
        self.itemToAdd = nil
        self.finding = nil
        self.repositioning = nil
    }
    
    /// Return to the inventory navigation view.
    public func AROff() {
        withAnimation {self.arViewMode = .none}
    }
    
    
    /// Show ar view where items can be placed.
    public func showGeneralView() {
        withAnimation{self.arViewMode = .general}
    }
    
    
    /// Show the space capture view.
    public func showMapSpaceView() {
        withAnimation{self.arViewMode = .mapSpace}
    }
    
    
    /// Show the ar view with reposition ability.
    /// - Parameter instance: ItemInstance to receive a new position
    public func showReposition(instance: ItemInstance) {
        self.repositioning = instance
        withAnimation{self.arViewMode = .repositionInstance}
    }
  
    
    /// Show the ar view with the ability to add an instance of the given item at a position.
    /// - Parameter item: Item that will have a new instance linked to it
    public func showAddInstance(item: Item) {
        self.itemToAdd = item
        withAnimation{self.arViewMode = .addInstance}
    }

    
    /// Show the given localization status of the abstract localization system in the user interface.
    /// - Parameter status: The state to be shown
    public func setLocalizationStatus(status: LocalizationStatus) {
        self.arLocalizationStatus = status
    }

    

    
    #if !(targetEnvironment(macCatalyst) || targetEnvironment(simulator))
    
    /// Get the space the real world has been matched to if the localization was successful.
    /// - Returns: Localized Space
    public func getSpace() -> Space? {
        return self.space
    }
    
    
    /// Update the view model with the space the real world has been matched to.
    /// - Parameter space: Localized Space from abstract localization system
    public func setSpace(space: Space) {
        self.space = space
    }
    
    
    /// Display a sheet to add a new item instance to the space.
    public func placeItem() {
        self.itemPosition = self.arCoordinator?.getItemPosition()
        self.setSheet(mode: .addItemView)
    }
    
    
    /// Show the ar view with the goal of displaying the position of the findable in the localized space.
    /// - Parameter finding: Findable to query the position of in the space
    public func showFind(finding: Findable) {
        self.finding = finding
        withAnimation{self.arViewMode = .findItem}
    }

    
    /// Change the to reposition item instance's position with a new position in this space.
    public func repositionInstance() {
        // Get new position and space
        guard let itemPosition = self.arCoordinator?.getItemPosition(),
              let repositionSpace = self.space,
              let moc = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext,
              let toReposition = self.repositioning else {
            return
        }
        
        // Add position to the space
        let position = Position(moc: moc, position: itemPosition, space: repositionSpace)
        
        // Set item instance's position
        _ = toReposition.setPosition(position: position)
        
        try? moc.save()
        
        // End AR
        self.AROff()
    
    }
    
    
    /// Add an ItemInstance to the to add Item with the current position in the localized space.
    public func addInstance() {
        guard let toAdd = self.itemToAdd,
              let itemPosition = self.arCoordinator?.getItemPosition(),
              let toAddSpace = self.space,
              let moc = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext else {
            return
        }
        
        // Add position to the space
        let position = Position(moc: moc, position: itemPosition, space: toAddSpace)
        
        // create item instance with the position
        _ = ItemInstance(moc: moc, item: toAdd, position: position, quantity: 1)
        
        try? moc.save()
        
        // End AR
        self.AROff()
        
    }
    
    
    /// Get the point cloud from the capture view for the add space sheet.
    private func setPointCloud() {
        let coordinator = self.arCaptureCoordinator
        let points = coordinator?.getPoints()
        self.pointCloud = points
        
        
    }
    
   
    /// End the space capture view and show the add space sheet.
    public func saveSpace() {
        self.setPointCloud()
        self.AROff()
        self.setSheet(mode: .addSpaceView)
    }
   
    #endif

    
    /// Directly display the desired sheet above the user interface.
    /// - Parameter mode: Type of sheet to be modally displayed
    public func setSheet(mode: ARSheet) {
        self.arSheetMode = mode
        self.isShowingSheet = true
    }
    
    
    /// Get the saved position of the device relative to the localized space's world origin.
    /// - Returns: The x y and z positions in meters if they exist
    public func getItemPosition() -> simd_float3? {
        return self.itemPosition
    }
    
    
    /// Get the saved point cloud vertices from the capture view.
    /// - Returns: The array of points representing a point cloud
    public func getPointCloud() -> [PointCloudVertex]? {
        return self.pointCloud
    }
    
    
}


/// Possible sheets that can be displayed modally above the ar view and navigation.
enum ARSheet: Equatable {
    case addSpaceView
    case addItemView
    case itemSelector
}
