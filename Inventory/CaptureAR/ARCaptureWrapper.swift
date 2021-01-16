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


final class ARCaptureWrapper: UIViewControllerRepresentable {

    var controller : InventoryController
    
    init(controller: InventoryController) {
        self.controller = controller
    }
    
    func makeCoordinator() -> ARCaptureCoordinator {
        let coordinator = Coordinator(self)
        controller.arCaptureCoordinator = coordinator
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

class ARCaptureCoordinator: NSObject, UINavigationControllerDelegate {
    var parent: ARCaptureWrapper?
    weak var child: CaptureViewController?
    
    init(_ parent: ARCaptureWrapper) {
        self.parent = parent
    }
    
    func getPoints() -> [PointCloudVertex] {
        return child?.getPoints() ?? [PointCloudVertex]()
    }
    
    
    
    
}

#endif
