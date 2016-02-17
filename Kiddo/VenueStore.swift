//
//  VenueStore.swift
//  Kiddo
//
//  Created by Clint Chilcott on 2/11/16.
//  Copyright © 2016 Clint Chilcott. All rights reserved.
//

import MapKit

enum ImageResult {
    case Success(UIImage)
    case Failure(ErrorType)
}

enum VenueError: ErrorType {
    case ImageCreationError
}

class VenueStore {
    
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