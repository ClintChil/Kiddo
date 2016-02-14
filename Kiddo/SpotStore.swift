//
//  BusinessStore.swift
//  Kiddo
//
//  Created by Clint Chilcott on 2/11/16.
//  Copyright © 2016 Clint Chilcott. All rights reserved.
//

import UIKit
import MapKit

class SpotStore {
    
    var allSpots = [Spot]()
    
    func create4Spots(name: String, coord: CLLocationCoordinate2D) -> Spot {
        let newSpot = Spot(name: name, coordinate: coord)
        allSpots.append(newSpot)
        
        return newSpot
    }

}
