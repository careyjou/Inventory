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
    convenience init(moc: NSManagedObjectContext, location: CLLocation) {
        self.init(context: moc)
        self.id = UUID()
        self.latitude = Float(location.coordinate.latitude)
        self.longitude = Float(location.coordinate.longitude)
    }
    
    public func getLocation() -> CLLocation? {
        return CLLocation(latitude: CLLocationDegrees(self.latitude), longitude: CLLocationDegrees(self.longitude))
    }
    
    public func setLocation(location: CLLocation) -> Location {
        self.latitude = Float(location.coordinate.latitude)
        self.longitude = Float(location.coordinate.longitude)
        return self
    }
    
    
    
}
