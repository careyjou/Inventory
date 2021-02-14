//
//  ARDisplayView.swift
//  Inventory
//
//  Created by Vincent Spitale on 5/18/20.
//  Copyright © 2020 Vincent Spitale. All rights reserved.
//

#if !(targetEnvironment(macCatalyst) || targetEnvironment(simulator))

import SwiftUI
import RealityKit
import CoreData
import ARKit


/// Wraps the augmented reality inventory viewer for use in SwiftUI.
final class ARViewWrapper: UIViewControllerRepresentable {
    init(viewModel: InventoryViewModel) {
        self.viewModel = viewModel
    }
    
    var viewModel: InventoryViewModel
    
    /// called implicitly to connect the delegate
    func makeCoordinator() -> ARCoordinator {
        let coordinator = Coordinator(self)
        viewModel.arCoordinator = coordinator
        return coordinator
        
    }
    
    
    /// Loads the storyboard and connects it to the ar view controller.
    /// - Parameter context: swiftui view wrapper
    /// - Returns: UIKit augmented reality view controller
    public func makeUIViewController(context: UIViewControllerRepresentableContext<ARViewWrapper>) -> ViewController {
        
        //Load the storyboard
        let loadedStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        //Load the ViewController
        let arView = loadedStoryboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        let coordinator = context.coordinator
        arView.delegate = coordinator
        arView.viewModel = self.viewModel
        coordinator.child = arView
        
        return arView
        
    }
    
    /// Nothing needs to be updated from the context because the ar view controller implements MVVM with combine.
    public func updateUIViewController(_ uiViewController: ViewController, context: UIViewControllerRepresentableContext<ARViewWrapper>) {
    }
}


/// Bridge to the augmented reality view of the real world.
class ARCoordinator: NSObject, UINavigationControllerDelegate {
    var parent: ARViewWrapper?
    weak var child: ViewController?
    
    init(_ parent: ARViewWrapper) {
        self.parent = parent
    }
    
    
    /// Gets the position of the device relative to the space's world origin.
    /// - Returns: Relative device position with six degrees of freedom
    public func getItemPosition() -> simd_float3? {
        if let child = self.child {
            return child.getItemPosition()
        }
        return nil
    }
    
    
    
    
    
}

#endif
