//
//  PointCloudVertex.swift
//  Inventory
//
//  Created by Vincent Spitale on 10/10/20.
//  Copyright © 2020 Vincent Spitale. All rights reserved.
//

import Foundation


/// Inventory's data type for a 3D point with r, g, b components.
public struct PointCloudVertex {
    let x: Float, y: Float, z: Float
    let r: Float, g: Float, b: Float
    

}

extension PointCloudVertex: Codable {
    
}
