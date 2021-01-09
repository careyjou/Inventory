//
//  LocationExtension.swift
//  Inventory
//
//  Created by Vincent Spitale on 1/8/21.
//  Copyright © 2021 Vincent Spitale. All rights reserved.
//

import Foundation
import MapKit

extension Location {
    public func getLocation() -> CLLocation? {
        return CLLocation(latitude: CLLocationDegrees(self.latitude), longitude: CLLocationDegrees(self.longitude))
    }
}
