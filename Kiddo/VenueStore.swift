//
//  VenueStore.swift
//  Kiddo
//
//  Created by Clint Chilcott on 2/11/16.
//  Copyright © 2016 Clint Chilcott. All rights reserved.
//

import UIKit //RF: I don't think you need UIKit imported here.
import MapKit

enum ImageResult {
    case Success(UIImage)
    case Failure(ErrorType)
}

enum VenueError: ErrorType {
    case ImageCreationError
}

//RF: Not sure I entirely understand the purpose of this class, I would just add the calls to a ServiceManager class, and then return the arrays like you are, then use an array in your VC in order to do stuff with the data, vs using this class, then init it in the AppDelegate, and then adding the Venue objects to this array in the ViewController calling these methods.
class VenueStore {
    
    var venues = [Venue]()
    
    let session: NSURLSession = {
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        return NSURLSession(configuration: config)
    }()
    
    func fetchNearbyVenues(coordinate coordinate: CLLocationCoordinate2D, query: String, completion: (VenuesResult) -> Void) {
        let url = FourSquareAPI.searchVenuesURL(coordinate, query: query)
        let request = NSURLRequest(URL: url)
        let task = session.dataTaskWithRequest(request) {
            (data, response, error) -> Void in
            
            let result = self.processRecentVenuesRequest(data: data, error: error)
            completion(result)
        }
        task.resume()
    }
    
    func processRecentVenuesRequest(data data: NSData?, error: NSError?) -> VenuesResult {
        guard let jsonData = data else {
            return .Failure(error!)
        }
        
        return FourSquareAPI.venuesFromJSONData(jsonData)
    }
    
    
    
}