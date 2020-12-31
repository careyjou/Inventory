//
//  ARViewCoordinator.swift
//  Inventory
//
//  Created by Vincent Spitale on 5/24/20.
//  Copyright © 2020 Vincent Spitale. All rights reserved.
//

import UIKit
import SwiftUI
import RealityKit
#if !(targetEnvironment(macCatalyst) || targetEnvironment(simulator))
import ARKit


class ViewController: UIViewController, ARSessionDelegate {
    @IBOutlet var arView: ARView!
    private var space: Space?
    weak open var delegate: ARCoordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let options = [ARSession.RunOptions.removeExistingAnchors,
                       ARSession.RunOptions.resetTracking]
        
        let configuration = ARWorldTrackingConfiguration()
        
        
        //self.arView.debugOptions.insert(.showWorldOrigin)
        //self.arView.debugOptions.insert(.showFeaturePoints)
        
        
        self.arView.renderOptions.remove(.disableMotionBlur)
        self.arView.renderOptions.remove(.disableCameraGrain)
        
        self.arView.session.run(configuration, options: ARSession.RunOptions(options))
        
        self.arView.session.delegate = self
        
        // The screen shouldn't dim during AR experiences.
        UIApplication.shared.isIdleTimerDisabled = true
        
    }
    
    
    func session(_ session: ARSession, didUpdate: ARFrame) {
        if (space == nil) {
            // see if current frame query matches space point cloud
            //didUpdate.camera.transform
        }
        
    }
    
    
    func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
        
    }
    
    
    
    func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
        
    }
    
    public func setSpace(space: Space, spacePosition: simd_float4x4) {
        self.setSpaceAnchor(spacePosition: spacePosition)
        self.space = space
        self.delegate?.hasSpace()
        
    }
    
    
    private func setSpaceAnchor(spacePosition: simd_float4x4) {
        
        arView.session.add(anchor: ARWorldAnchor(column0: spacePosition.columns.0, column1: spacePosition.columns.1, column2: spacePosition.columns.2, column3: spacePosition.columns.3))
        
    }
    
    
    public func hasSpace() -> Bool {
        return self.space != nil
    }
    
    
    public func getSpace() -> Space? {
        return self.space
    }
    
    public func getItemPosition() -> simd_float3 {
        let frame = arView.session.currentFrame!
        
        let anchors = frame.anchors
        
        let camera = frame.camera.transform
        
        
        var spacePosition: simd_float4x4 = simd_float4x4()
        
        for anchor in anchors {
            if (anchor is ARWorldAnchor) {
                spacePosition = anchor.transform
                
                break
                
            }
        }
        
        let relativePosition = spacePosition.inverse * camera
         
        return simd_float3(x: Float(relativePosition.columns.3.x), y: Float(relativePosition.columns.3.y), z: Float(relativePosition.columns.3.z))
        
        
    }
    

    
}

#endif

