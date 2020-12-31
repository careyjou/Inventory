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


final class ARViewWrapper: UIViewControllerRepresentable {
    init(controller: InventoryController) {
        self.controller = controller
    }
    
    var controller: InventoryController
    
    func makeCoordinator() -> ARCoordinator {
        let coordinator = Coordinator(self)
        controller.arCoordinator = coordinator
        return coordinator
        
    }

  public func makeUIViewController(context: UIViewControllerRepresentableContext<ARViewWrapper>) -> ViewController {
    
    //Load the storyboard
    let loadedStoryboard = UIStoryboard(name: "Main", bundle: nil)
    
    //Load the ViewController
    let arView = loadedStoryboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
    let coordinator = context.coordinator
    arView.delegate = coordinator
    coordinator.child = arView
    
    return arView
    
  }
  
  public func updateUIViewController(_ uiViewController: ViewController, context: UIViewControllerRepresentableContext<ARViewWrapper>) {
  }
}

class ARCoordinator: NSObject, UINavigationControllerDelegate {
    weak var parent: ARViewWrapper?
    weak var child: ViewController?
    
    init(_ parent: ARViewWrapper) {
        self.parent = parent
    }
    
    public func getSpace() -> Space? {
        if let child = self.child {
            return child.getSpace()
        }
        return nil
    }
    
    public func hasSpace() {
        parent?.controller.arHasSpace = true
    }
    
    public func getItemPosition() -> simd_float3? {
        if let child = self.child {
            return child.getItemPosition()
        }
        return nil
    }
    
    
    
    
    
}

#endif
