//
//  ARViewMode.swift
//  Inventory
//
//  Created by Vincent Spitale on 5/18/20.
//  Copyright © 2020 Vincent Spitale. All rights reserved.
//

import Foundation

enum ARViewMode: Equatable {
    // ar view is off
    case none
    // can place items
    case general
    // add instance of view model toAdd item
    case addInstance
    // to set a new position for the view model's toreposition instance
    // in the localized space
    case repositionInstance
    // to find where a findable type is in a localized space
    case findItem
    // mode to capture a point cloud of a space
    case mapSpace
   
        
}

enum LocalizationStatus: Equatable {
    case capturing
    case localizing
    case foundSpace
    case errorLocalizing
    
    /// Get the localization status description of this state.
    /// - Returns: Status description
    public func statusText() -> String {
        switch self {
        case .capturing:
            return "Capturing"
        case .localizing:
            return "Localizing"
        case .foundSpace:
            return "Localized"
        case .errorLocalizing:
            return "Unable to Localize"
        }
    }
}
