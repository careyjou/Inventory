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
    
    /// Create an identifiable Location with a managed context and location.
    /// - Parameters:
    ///   - moc: CoreData context
    ///   - location: Geographical location
    convenience init(moc: NSManagedObjectContext, location: CLLocation) {
        self.init(context: moc)
        self.id = UUID()
        self.latitude = Float(location.coordinate.latitude)
        self.longitude = Float(location.coordinate.longitude)
    }
    
    /// Get a geographical location from this
    /// - Returns: The geographical coordinates
    public func getLocation() -> CLLocation? {
        return CLLocation(latitude: CLLocationDegrees(self.latitude), longitude: CLLocationDegrees(self.longitude))
    }
    

    
    
}
