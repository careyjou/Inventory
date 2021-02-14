//
//  LocationExtension.swift
//  Inventory
//
//  Created by Vincent Spitale on 1/8/21.
//  Copyright © 2021 Vincent Spitale. All rights reserved.
//

import Foundation
import MapKit
import CoreData

extension Location {
    
    /// <#Description#>
    /// - Parameters:
    ///   - moc: <#moc description#>
    ///   - location: <#location description#>
    convenience init(moc: NSManagedObjectContext, location: CLLocation) {
        self.init(context: moc)
        self.id = UUID()
        self.latitude = Float(location.coordinate.latitude)
        self.longitude = Float(location.coordinate.longitude)
    }
    
    /// <#Description#>
    /// - Returns: <#description#>
    public func getLocation() -> CLLocation? {
        return CLLocation(latitude: CLLocationDegrees(self.latitude), longitude: CLLocationDegrees(self.longitude))
    }
    
    /// <#Description#>
    /// - Parameter location: <#location description#>
    /// - Returns: <#description#>
    public func setLocation(location: CLLocation) -> Location {
        self.latitude = Float(location.coordinate.latitude)
        self.longitude = Float(location.coordinate.longitude)
        return self
    }
    
    
    
}
