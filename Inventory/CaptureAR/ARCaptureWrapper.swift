//
//  ARCaptureWrapper.swift
//  Inventory
//
//  Created by Vincent Spitale on 9/19/20.
//  Copyright © 2020 Vincent Spitale. All rights reserved.
//


#if !(targetEnvironment(macCatalyst) || targetEnvironment(simulator))

import SwiftUI
import RealityKit
import CoreData
import ARKit


/// A SwiftUI compatible wrapper for the point cloud capture view.
final class ARCaptureWrapper: UIViewControllerRepresentable {
    
    var viewModel : InventoryViewModel
    
    init(viewModel: InventoryViewModel) {
        self.viewModel = viewModel
    }
    
    func makeCoordinator() -> ARCaptureCoordinator {
        let coordinator = Coordinator(self)
        viewModel.arCaptureCoordinator = coordinator
        return coordinator
        
    }
    
    public func makeUIViewController(context: UIViewControllerRepresentableContext<ARCaptureWrapper>) -> CaptureViewController {
        
        //Load the storyboard
        let loadedStoryboard = UIStoryboard(name: "Capture", bundle: nil)
        
        //Load the ViewController
        let arView = loadedStoryboard.instantiateViewController(withIdentifier: "CaptureViewController") as! CaptureViewController
        let coordinator = context.coordinator
        arView.delegate = coordinator
        coordinator.child = arView
        
        return arView
        
    }
    
    public func updateUIViewController(_ uiViewController: CaptureViewController, context: UIViewControllerRepresentableContext<ARCaptureWrapper>) {
    }
}


/// Interfaces with the point cloud capture view controller so the point cloud can be saved.
class ARCaptureCoordinator: NSObject, UINavigationControllerDelegate {
    var parent: ARCaptureWrapper?
    weak var child: CaptureViewController?
    
    init(_ parent: ARCaptureWrapper) {
        self.parent = parent
    }
    
    
    /// Get all of the points the point cloud capture view controller has.
    /// - Returns: A collection of point cloud points
    func getPoints() -> [PointCloudVertex] {
        return child?.getPoints() ?? [PointCloudVertex]()
    }
    
    
    
    
}

#endif
