//
//  GOICPPose.swift
//  Inventory
//
//  Created by Vincent Spitale on 1/15/21.
//  Copyright © 2021 Vincent Spitale. All rights reserved.
//

import Foundation

class GoICPPose: CameraPoseFinder {
    
    public func cameraPose(source: PointCloud, destination: PointCloud) -> CameraPoseResult? {
        let scaledClouds = self.scalePointClouds(source: source, destination: destination)
        
        let scaledQueryCloud = scaledClouds.scaledQueryPointCloud
        let scaledReferenceCloud = scaledClouds.scaledReferencePointCloud
        
        let unsafeQueryCloud = UnsafeMutableBufferPointer<POINT3D>.allocate(capacity: scaledQueryCloud.count)
            
        _ = unsafeQueryCloud.initialize(from: scaledQueryCloud)
        
        let unsafeReferenceCloud = UnsafeMutableBufferPointer<POINT3D>.allocate(capacity: scaledReferenceCloud.count)
        
        
        _ = unsafeReferenceCloud.initialize(from: scaledReferenceCloud)
        
       
        guard let unsafeQueryPointer = unsafeQueryCloud.baseAddress else {
            return nil
        }
        
        guard let unsafeReferencePointer = unsafeReferenceCloud.baseAddress else {
            return nil
        }
        
        
        let cameraPose = CameraPoseFinder_Wrapper().getCameraPose(unsafeQueryPointer, sourceSize: Int32(scaledClouds.scaledQueryPointCloud.count), destination: unsafeReferencePointer, destinationSize: Int32(scaledClouds.scaledReferencePointCloud.count))
        
        // initially unscaled
        var pose = simd_float4x4(cameraPose.matrix)
        // undo scaling
        pose.columns.3.x = pose.columns.3.x / scaledClouds.scaleFactor
        pose.columns.3.y = pose.columns.3.y / scaledClouds.scaleFactor
        pose.columns.3.z = pose.columns.3.z / scaledClouds.scaleFactor
        
        return CameraPoseResult(pose: pose, confidence: cameraPose.error)
    }
    
    
    
    /// The c++ implementation of the go icp algorithm requires that both clouds fit within 1 unit cubed.
    /// Therefore, the point clouds need to be scaled down by the same scale factor for them to be aligned.
    /// This is done by finding the maximum dimensions and scaling down by the largest outlier.
    /// - Parameters:
    ///   - source:
    ///   - destination:
    /// - Returns: The query point cloud appropriately scaled, the reference point cloud appropriately scaled (both losing color information), and the scale factor
    private func scalePointClouds(source: PointCloud, destination: PointCloud) -> ScaledPointCloudsResult {
        var maxDimension: Float = 0.001
        for p in source.getPointCloud() {
            maxDimension = max(maxDimension, abs(p.x),abs(p.y),abs(p.z))
        }
        
        for p in destination.getPointCloud() {
            maxDimension = max(maxDimension, abs(p.x),abs(p.y),abs(p.z))
        }
        
        let scaleFactor: Float = 0.499 / maxDimension
        let scaledQueryPointCloud = self.scaleCloud(cloud: source, scaleFactor: scaleFactor)
        let scaledReferencePointCloud = self.scaleCloud(cloud: destination, scaleFactor: scaleFactor)
        
        return ScaledPointCloudsResult(scaledQueryPointCloud: scaledQueryPointCloud, scaledReferencePointCloud: scaledReferencePointCloud, scaleFactor: scaleFactor)
    }

    private func scaleCloud(cloud: PointCloud, scaleFactor: Float) -> [POINT3D] {
        let points = cloud.getPointCloud()
        return points.map({POINT3D(x: $0.x * scaleFactor, y: $0.y * scaleFactor, z: $0.z * scaleFactor)})
    }
    
    struct ScaledPointCloudsResult {
        let scaledQueryPointCloud: [POINT3D]
        let scaledReferencePointCloud: [POINT3D]
        let scaleFactor: Float
    }

    
}

