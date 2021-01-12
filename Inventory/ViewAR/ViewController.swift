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
import CoreLocation
import Metal
import MetalKit
#if !(targetEnvironment(macCatalyst) || targetEnvironment(simulator))
import ARKit


class ViewController: UIViewController, ARSessionDelegate, CLLocationManagerDelegate {
    @IBOutlet var arView: ARView!
    private var cameraPose: CameraPoseResult?
    private var spaceAnchor: ARWorldAnchor?
    weak open var delegate: ARCoordinator?
    private var renderer: Renderer!
    private var isFindingCameraPose: Bool = false
    private var locationManager = CLLocationManager()
    
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
        
        guard let device = MTLCreateSystemDefaultDevice() else {
            print("Metal is not supported on this device")
            return
        }
        
        // Set the view to use the default device
        
        
        
        let mtkView = MTKView()
        
            mtkView.device = device
            
            view.backgroundColor = UIColor.clear
            // we need this to enable depth test
            mtkView.depthStencilPixelFormat = .depth32Float
            view.contentScaleFactor = 1
            
            // Configure the renderer to draw to the view
            renderer = Renderer(session: arView.session, metalDevice: device, renderDestination: mtkView)
            renderer.drawRectResized(size: view.bounds.size)
        
        
        
        
        self.getLocation()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a world-tracking configuration, and
        // enable the scene depth frame-semantic.
        let configuration = ARWorldTrackingConfiguration()
        configuration.frameSemantics = .sceneDepth

        // Run the view's session
        arView.session.run(configuration)
        
        // The screen shouldn't dim during AR experiences.
        UIApplication.shared.isIdleTimerDisabled = true
    }
    
    @IBAction func getLocation() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.startUpdatingLocation()
    }
    
    
    func session(_ session: ARSession, didUpdate: ARFrame) {
        if (cameraPose?.space == nil && (renderer.numPoints() < 20000)) {
            renderer.gatherPoints()
        }
        else if (!self.isFindingCameraPose && cameraPose?.space == nil && renderer.numPoints() >= 20000) {
            let queryPoints = renderer.getPoints()
            self.isFindingCameraPose = true
            guard let cameraPoseLocalizer = CameraPoseLocalizer() else {
                return
            }
            
            print("Started Registration")
            
            
                if let result = cameraPoseLocalizer.getCameraPose(queryPointCloud: PointCloud(pointCloud: queryPoints), location: self.locationManager.location) {
                        self.setCameraPose(pose: result)
                        print("found space")
                    
                }
                
            
            
        }
        
    }
    
    
    func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
        
    }
    
    
    
    func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
        
    }
    
    public func setCameraPose(pose: CameraPoseResult) {
        self.setSpaceAnchor(spacePosition: pose.pose)
        self.cameraPose = pose
        self.isFindingCameraPose = false
        self.delegate?.hasSpace()
        
    }
    
    
    private func setSpaceAnchor(spacePosition: simd_float4x4) {
        let anchor = ARWorldAnchor(column0: spacePosition.columns.0, column1: spacePosition.columns.1, column2: spacePosition.columns.2, column3: spacePosition.columns.3)
        self.spaceAnchor = anchor
        
        arView.session.add(anchor: anchor)
        
    }
    
    
    public func hasSpace() -> Bool {
        return self.cameraPose?.space != nil
    }
    
    
    public func getSpace() -> Space? {
        return self.cameraPose?.space
    }
    
    public func getItemPosition() -> simd_float3? {
        let frame = arView.session.currentFrame!
        
        let camera = frame.camera.transform
        
        guard let inverse = self.cameraPose?.pose.inverse else {
            return nil
        }
        
        let relativePosition = inverse * camera
         
        return simd_float3(x: Float(relativePosition.columns.3.x), y: Float(relativePosition.columns.3.y), z: Float(relativePosition.columns.3.z))
        
        
    }
    

    
}



#endif

