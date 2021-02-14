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
import Combine
#if !(targetEnvironment(macCatalyst) || targetEnvironment(simulator))
import ARKit


/// Augmented reality view for displaying the position of items in a localized space.
class ViewController: UIViewController, ARSessionDelegate, CLLocationManagerDelegate {
    @IBOutlet var arView: ARView!
    // where the space's point cloud's world origin maps to in this view
    private var cameraPose: SpacePoseResult?
    // world origin of the space's point cloud
    private var spaceAnchor: AnchorEntity?
    // sphere to be displayed
    private var itemPosition: ModelEntity?
    
    weak open var delegate: ARCoordinator?
    
    // used for discretely capturing a query point cloud to be localized
    private var renderer: Renderer!
    
    // determines if more points will be captured
    private var isFindingCameraPose: Bool = false
    private var locationManager = CLLocationManager()
    
    private var disposables = Set<AnyCancellable>()
    var viewModel: InventoryViewModel?
    
    
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
        
        // to follow the MVVM pattern, changes to the findable and arMode will trigger functions to be called
        self.bindFindable()
        self.bindARViewMode()
        
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
    
    /// Starts gathering location data so the localization algorithm can improve its search.
    @IBAction func getLocation() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.startUpdatingLocation()
    }
    
    
    
    /// Gather points or localize if applicable.
    /// - Parameters:
    ///   - session: augmented reality session
    ///   - didUpdate: current augmented reality view
    func session(_ session: ARSession, didUpdate: ARFrame) {
        if (cameraPose?.space == nil && (renderer.numPoints() < 20000)) {
            renderer.gatherPoints()
        }
        else if (!self.isFindingCameraPose && !isLocalized() && renderer.numPoints() >= 20000) {
            let queryPoints = renderer.getPoints()
            self.isFindingCameraPose = true
            guard let cameraPoseLocalizer = CameraPoseLocalizer() else {
                return
            }
            
            print("Started Registration")
            
            self.sendLocalizationStatus(status: .localizing)
            
            // localization should not be run on the main thread because it would freeze the ui and interfere with the ARKit's SLAM
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                if let result = cameraPoseLocalizer.getCameraPose(queryPointCloud: PointCloud(pointCloud: queryPoints), location: self?.locationManager.location, poseFinder: GoICPPose()) {
                    DispatchQueue.main.async {
                        self?.setCameraPose(pose: result)
                        print("found space")
                        self?.sendLocalizationStatus(status: .foundSpace)
                        if let finding = self?.viewModel?.finding {
                            self?.animateItemPosition(findable: finding)
                        }
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
    
    
    
    /// Update the view model with the camera pose.
    /// - Parameter pose: camera pose in space
    private func setCameraPose(pose: SpacePoseResult) {
        self.setSpaceAnchor(spacePosition: pose.pose)
        self.cameraPose = pose
        self.isFindingCameraPose = false
        self.viewModel?.space = pose.space
        
    }
    
    
    /// Add an AR anchor with the pose from the camera pose result.
    /// - Parameter spacePosition: pose of the reference point cloud in this AR scene
    private func setSpaceAnchor(spacePosition: simd_float4x4) {
        let anchor = AnchorEntity(.world(transform: spacePosition))
        self.spaceAnchor = anchor
        
        arView.scene.addAnchor(anchor)
        
        
    }
    
    
    /// Has the real world been matched to a camera pose?
    /// - Returns: does this ar scene have a camera pose
    private func isLocalized() -> Bool {
        return self.cameraPose != nil
    }
    
    
    /// Get the camera pose's space if the world has been localized.
    /// - Returns: space the real world has been matched to
    private func getSpace() -> Space? {
        return self.cameraPose?.space
    }
    
    
    /// Get the device's camera pose in the relative to the space's world origin if there is a camera pose result.
    /// - Returns: The device's camera pose with six degrees of freedom
    public func getItemPosition() -> simd_float3? {
        let frame = arView.session.currentFrame!
        
        let camera = frame.camera.transform
        
        guard let pose = self.cameraPose?.pose else {
            return nil
        }
        
        let relativePosition = pose.inverse * camera
        
        return simd_float3(x: Float(relativePosition.columns.3.x), y: Float(relativePosition.columns.3.y), z: Float(relativePosition.columns.3.z))
        
        
    }
    
    
    /// Adds a sphere to the scene where the given findable is located and begins playing spatial audio.
    /// - Parameter findable: A type that can provide a position if provided with a space
    public func animateItemPosition(findable: Findable) {
        self.removeSpheres()
        
        guard let space = self.getSpace(),
              let position = findable.getTransform(space: space) else {
            return // cannot animate if we do not have a recognized space and position of the item
        }
        
        /*
         let column0 = simd_float4(x: 1, y: 0, z: 0, w: 0)
         let column1 = simd_float4(x: 0, y: 1, z: 0, w: 0)
         let column2 = simd_float4(x: 0, y: 0, z: 1, w: 0)
         var column3 = simd_float4(x: 0, y: 0, z: 0, w: 1)
         
         column3.x = position.x
         column3.y = position.y
         column3.z = position.z
         
         let transform = simd_float4x4(columns: (column0, column1, column2, column3))
         */
        
        
        let brightWhite = UnlitMaterial(color: .white)
        
        
        let fixedItemPosition = ModelEntity(mesh: .generateSphere(radius: 0.05), materials: [brightWhite])
        
        
        fixedItemPosition.move(to: Transform(translation: position), relativeTo: .none)
        
        // add entity so realitykit will render it
        spaceAnchor?.addChild(fixedItemPosition)
        
        self.itemPosition = fixedItemPosition
        
        guard let soundUrl = Bundle.main.url(forResource: "Blow", withExtension: "aiff"),
              let beaconSound = try? AudioFileResource.load(contentsOf: soundUrl, inputMode: .spatial, loadingStrategy: .preload, shouldLoop: true) else {
            return
        }
        
        // play spatial audio
        
        let audioController = fixedItemPosition.prepareAudio(beaconSound)
        audioController.play()
        
        
    }
    
    
    /// Show the position of the findable in the real world.
    /// - Parameter toFind: type we can query the position of in a space
    public func setFinding(toFind: Findable) {
        self.animateItemPosition(findable: toFind)
    }
    
    
    /// Stops showing the position and spatial audio of the findable.
    public func removeSpheres() {
        self.itemPosition?.removeFromParent()
        
        self.itemPosition = nil
    }
    
    
    /// Sets functions to be run when changes are made to the findable binding
    /// so the position will be shown instantaneously.
    private func bindFindable() {
        self.viewModel?.$finding
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: {[weak self] toFind in
                if let find = toFind {
                    self?.viewModel?.arViewMode = .findItem
                    self?.setFinding(toFind: find)
                    
                }
            }).store(in: &disposables)
    }
    
    
    /// Sets functions to be run when the ar view mode changes so that the item that
    /// is being searched for is hidden.
    private func bindARViewMode() {
        self.viewModel?.$arViewMode
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: {[weak self] arMode in
                if arMode != .findItem && arMode != .none {
                    self?.viewModel?.finding = nil
                    self?.removeSpheres()
                }
            })
            .store(in: &disposables)
    }
    
    
    /// Notify the view model of what the localization status is so that the user is informed.
    /// - Parameter status: Current state of the abstract localization system
    private func sendLocalizationStatus(status: LocalizationStatus) {
        self.viewModel?.setLocalizationStatus(status: status)
    }
    
    
    
}



#endif

