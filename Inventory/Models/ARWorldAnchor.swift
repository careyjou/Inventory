//
//  ARWorldAnchor.swift
//  Inventory
//
//  Created by Vincent Spitale on 9/13/20.
//  Copyright © 2020 Vincent Spitale. All rights reserved.
//

import Foundation
import ARKit

class ARWorldAnchor: ARAnchor {
    init(column0: SIMD4<Float> = [1,0,0,0],
         column1: SIMD4<Float> = [0,1,0,0],
         column2: SIMD4<Float> = [0,0,1,0],
         column3: SIMD4<Float> = [0,0,0,1]) {
        let transform = simd_float4x4(columns: (column0,
                                                column1,
                                                column2,
                                                column3))
        let worldAnchor = ARAnchor(name: "World Anchor",
                              transform: transform)
        super.init(anchor: worldAnchor)
    }
    required init(anchor: ARAnchor) {
        super.init(anchor: anchor)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("Hasn't been implemented yet...")
    }
}
