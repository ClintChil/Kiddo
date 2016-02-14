//
//  Spot.swift
//  Kiddo
//
//  Created by Clint Chilcott on 2/11/16.
//  Copyright © 2016 Clint Chilcott. All rights reserved.
//

import UIKit
import MapKit

class Spot: NSObject, MKAnnotation {
    
    let name: String
    let coordinate: CLLocationCoordinate2D
    var title: String? { return name }
    var subtitle: String? { return name }
    
    init(name: String, coordinate: CLLocationCoordinate2D) {
        self.name = name
        self.coordinate = coordinate
    }
}

