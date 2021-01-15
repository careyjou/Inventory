//
//  PointCloudView.swift
//  Inventory
//
//  Created by Vincent Spitale on 10/4/20.
//  Copyright © 2020 Vincent Spitale. All rights reserved.
//

import Foundation
import SwiftUI
import SceneKit

struct PointCloudView: UIViewRepresentable {
    @ObservedObject var space: Space
    @ObservedObject var data: SpacePointCloudAppData
    
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
        
        if let cloud = data.getPointCloud(space: space) {
            DispatchQueue.main.async{
                let points = cloud.getPointCloud()
                
                let vertexData = NSData(
                            bytes: points,
                            length: MemoryLayout<PointCloudVertex>.size * points.count
                        )
                        let positionSource = SCNGeometrySource(
                            data: vertexData as Data,
                            semantic: SCNGeometrySource.Semantic.vertex,
                            vectorCount: points.count,
                            usesFloatComponents: true,
                            componentsPerVector: 3,
                            bytesPerComponent: MemoryLayout<Float>.size,
                            dataOffset: 0,
                            dataStride: MemoryLayout<PointCloudVertex>.size
                        )
                        let colorSource = SCNGeometrySource(
                            data: vertexData as Data,
                            semantic: SCNGeometrySource.Semantic.color,
                            vectorCount: points.count,
                            usesFloatComponents: true,
                            componentsPerVector: 3,
                            bytesPerComponent: MemoryLayout<Float>.size,
                            dataOffset: MemoryLayout<Float>.size * 3,
                            dataStride: MemoryLayout<PointCloudVertex>.size
                        )
                        let elements = SCNGeometryElement(
                            data: nil,
                            primitiveType: .point,
                            primitiveCount: points.count,
                            bytesPerIndex: MemoryLayout<Int>.size
                        )
                
                        // for bigger dots
                        elements.pointSize = 2
                        elements.minimumPointScreenSpaceRadius = 2
                        elements.maximumPointScreenSpaceRadius = 2
                    
                
                    
                
                        let geometry = SCNGeometry(sources: [positionSource, colorSource],
                                                   elements: [elements])
                        
                        let material = SCNMaterial()
                        material.diffuse.contents = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                        material.lightingModel = .constant
                        geometry.firstMaterial = material
                        
 
                    let node = SCNNode()
                    
                    node.geometry = geometry
                    
                
            
                    scene.rootNode.addChildNode(node)
                
            
            }
        }
        
        
    }
    

}



