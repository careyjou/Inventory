//
//  PointCloudVertex.swift
//  Inventory
//
//  Created by Vincent Spitale on 10/10/20.
//  Copyright © 2020 Vincent Spitale. All rights reserved.
//

import Foundation

public struct PointCloudVertex {
    let x: Float, y: Float, z: Float
    let r: Float, g: Float, b: Float
    

}

extension PointCloudVertex: Codable {
    
}
