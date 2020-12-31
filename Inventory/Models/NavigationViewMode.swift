//
//  ViewMode.swift
//  Inventory
//
//  Created by Vincent Spitale on 5/17/20.
//  Copyright © 2020 Vincent Spitale. All rights reserved.
//

import Foundation

enum NavigationViewMode {
    case item
    case space
   
    public func title() -> String {
        switch self {
        case .item:
            return "Items"
        case .space:
            return "Spaces"
        }
    }
    
}
