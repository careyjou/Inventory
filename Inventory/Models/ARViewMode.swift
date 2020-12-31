//
//  ARViewMode.swift
//  Inventory
//
//  Created by Vincent Spitale on 5/18/20.
//  Copyright © 2020 Vincent Spitale. All rights reserved.
//

import Foundation

enum ARViewMode {
    case general
    case addItem
    case addInstance
    case repositionInstance
    case findItem
    case mapSpace
    case enhanceSpace
   
    public func buttonText() -> String {
        switch self {
        case .general:
            return ""
        case .addItem:
            return "Place Item"
        case .addInstance:
            return "Place Instance"
        case .repositionInstance:
            return "Reposition Item"
        case .findItem:
            return ""
        case .mapSpace:
            return "Add Space"
        case .enhanceSpace:
            return "Enhance Space"
        }
    }
    
}
