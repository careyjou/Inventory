//
//  UISceneView.swift
//  Inventory
//
//  Created by Vincent Spitale on 8/22/20.
//  Copyright © 2020 Vincent Spitale. All rights reserved.
//

import Foundation
import SwiftUI
import SceneKit

public struct ModelView: UIViewRepresentable {
    
    public var filePath: URL? = nil
    public var isRotating: Bool = true

    
    public typealias UIViewType = SCNView
    
    
    
    public func makeUIView(context: Context) -> Self.UIViewType {
        let view = SCNView()
        let scene = SCNScene()
        self.updateModel(scene: scene)
        view.scene = scene
        view.backgroundColor = .clear
        view.autoenablesDefaultLighting = true
        view.allowsCameraControl = true
        
        
        
        return view
    }
    
    public func updateUIView(_ uiView: Self.UIViewType, context: Context) {
        let scene = SCNScene()
        self.updateModel(scene: scene)
 
    }
    
    private func updateModel(scene: SCNScene) {
        if isRotating {
        self.startRotation(scene: scene)
        }
        if (filePath != nil) {
        
            DispatchQueue.main.async{
                do {
                    let newScene = try SCNScene(url: filePath!)
                    scene.rootNode.addChildNode(newScene.rootNode)
            }
                catch {
                    print("could not open file")
                }
            }
        }
        
    }
        
        
    
    
    private func startRotation(scene: SCNScene) {
        let node = scene.rootNode
        let spin = CABasicAnimation(keyPath: "rotation")
        // Use from-to to explicitly make a full rotation around z
        spin.fromValue = NSValue(scnVector4: SCNVector4(x: 0, y: 1, z: 0, w: 0))
        spin.toValue = NSValue(scnVector4: SCNVector4(x: 0, y: 1, z: 0, w: Float(CGFloat(2 * Double.pi))))
        spin.duration = 30
        spin.repeatCount = .infinity
        node.addAnimation(spin, forKey: "spin around")
    }
    
    
}
