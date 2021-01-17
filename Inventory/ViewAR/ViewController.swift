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
    private var cameraPose: SpacePoseResult?
    private var spaceAnchor: AnchorEntity?
    private var itemPosition: ModelEntity?
    private var movingItemPosition: ModelEntity?
    
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
            
            self.sendLocalizationStatus(status: .localizing)

            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                if let result = cameraPoseLocalizer.getCameraPose(queryPointCloud: PointCloud(pointCloud: queryPoints), location: self?.locationManager.location, poseFinder: GoICPPose()) {
                    DispatchQueue.main.async {
                        self?.setCameraPose(pose: result)
                        print("found space")
                        self?.sendLocalizationStatus(status: .foundSpace)
                    }
                
                }
                else {
                    DispatchQueue.main.async {
                        self?.sendLocalizationStatus(status: .errorLocalizing)
                    }
                }
            }
 
            
        }
        
    }
    
    
    func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
        
    }
    
    
    
    func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
        
    }
    
    public func setCameraPose(pose: SpacePoseResult) {
        self.setSpaceAnchor(spacePosition: pose.pose)
        self.cameraPose = pose
        self.isFindingCameraPose = false
        self.delegate?.hasSpace()
        
    }
    
    
    private func setSpaceAnchor(spacePosition: simd_float4x4) {
        let anchor = AnchorEntity(.world(transform: spacePosition))
        self.spaceAnchor = anchor
        
        arView.scene.addAnchor(anchor)
        
        
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
    
    
    public func animateItemPosition(finding: Findable) {
        self.removeSpheres()
        
        guard let space = self.getSpace(),
              let position = finding.getTransform(space: space) else {
            return
        }
        
        
        let frame = arView.session.currentFrame!
        
        let camera = frame.camera.transform
        
        
        let brightWhite = UnlitMaterial(color: .white)
                               
                               
        let fixedItemPosition = ModelEntity(mesh: .generateSphere(radius: 0.05), materials: [brightWhite])
        
        let animatingPosition = ModelEntity(mesh: .generateSphere(radius: 0.05), materials: [brightWhite])
        
        animatingPosition.position = simd_float3(x: camera.columns.3.x, y: camera.columns.3.y, z: camera.columns.3.z)
        
        fixedItemPosition.position = position
        
        spaceAnchor?.addChild(fixedItemPosition)
        spaceAnchor?.addChild(animatingPosition)
        
        self.itemPosition = fixedItemPosition
        self.movingItemPosition = animatingPosition
        
        let column0 = simd_float4(x: 1, y: 0, z: 0, w: 0)
        let column1 = simd_float4(x: 0, y: 1, z: 0, w: 0)
        let column2 = simd_float4(x: 0, y: 0, z: 1, w: 0)
        var column3 = simd_float4(x: 0, y: 0, z: 0, w: 1)
        
        column3.x = position.x - camera.columns.3.x
        column3.y = position.y - camera.columns.3.y
        column3.z = position.z - camera.columns.3.z
        
        let transform = simd_float4x4(columns: (column0, column1, column2, column3))
        
        let length = powf((powf(position.x - camera.columns.3.x, 2) + powf(position.y - camera.columns.3.y, 2) + powf(position.z - camera.columns.3.z, 2)), 0.5) * 3
        
        animatingPosition.move(to: transform, relativeTo: .none, duration: TimeInterval(length))
        
        
    }
    
    public func setFinding(toFind: Findable) {
        self.animateItemPosition(finding: toFind)
    }
    
    public func removeSpheres() {
        self.itemPosition?.removeFromParent()
        self.movingItemPosition?.removeFromParent()
        
        self.itemPosition = nil
        self.movingItemPosition = nil
    }
    
    
    
    private func sendLocalizationStatus(status: LocalizationStatus) {
        self.delegate?.setLocalizationStatus(status: status)
    }
    
}



#endif

