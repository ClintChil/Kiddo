//
//  FourSquareAPI.swift
//  Kiddo
//
//  Created by Clint Chilcott on 2/11/16.
//  Copyright © 2016 Clint Chilcott. All rights reserved.
//

import Foundation
import MapKit

enum Method: String {
    case SearchVenues = "venues/search"
}

enum VenuesResult { //RF: I like this a lot
    case Success([Venue])
    case Failure(ErrorType)
}

enum FourSquareError: ErrorType {
    case InvalidJSONData
}

struct FourSquareAPI {
    
    //RF: Would generally want to protect this sensitive data, espicially since it is public, I would probably put into a plist, and ignore it in git. Then fetch values from the plist here.
    private static let baseURLString = "https://api.foursquare.com/v2/"
    private static let clientID = "KC1V3HJV3AORNIIH4VXQM42NA4WYZOLAA5GXVZSJIGRCUN1Q"
    private static let clientSecret = "KON3QATMIHYOYZXI4IJPGCIZUVQACVSLH0S3RZYPIJYID5OX"
    private static let versionOfAPI = "20160215"
    
    //RF: I put all of my data fomatting code into an NSDate extension. Makes it so you can reuse any where in your application easily.
    private static let dateFormatter: NSDateFormatter = {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter
    }()
    
    private static func fourSquareURL(method method: Method, parameters: [String:String]?) -> NSURL {
        
        // FIXME: change this to use NSURLComponents host & path, not string concatenation
        let components = NSURLComponents(string: baseURLString + method.rawValue)!
        
        var queryItems = [NSURLQueryItem]()
        let baseParams = [
            "client_id": clientID,
            "client_secret": clientSecret,
            "v": versionOfAPI
        ]
        
        for (key, value) in baseParams {
            let item = NSURLQueryItem(name: key, value: value)
            queryItems.append(item)
        }
        
        if let additionalParams = parameters {
            for (key, value) in additionalParams {
                let item = NSURLQueryItem(name: key, value: value)
                queryItems.append(item)
            }
        }
        components.queryItems = queryItems
        
        return components.URL!
    }
    
    static func searchVenuesURL(coordinate: CLLocationCoordinate2D, query: String) -> NSURL {
        let coordinateString = "\(coordinate.latitude),\(coordinate.longitude)"
        return fourSquareURL(method: .SearchVenues, parameters: ["ll": coordinateString, "query": query])
    }
    
    static func venuesFromJSONData(data: NSData) -> VenuesResult {
        do {
            let jsonObject: AnyObject = try NSJSONSerialization.JSONObjectWithData(data, options: [])
            guard let
                //RF: General dictionary formatting I see used with swift is [String: AnyObject]
                jsonDictionary = jsonObject as? [String:AnyObject],
                venues = jsonDictionary["response"] as? [String:AnyObject],
                venuesArray = venues["venues"] as? [[String:AnyObject]] else {
                    
                    // The JSON structure doesn't match our expectations
                    return .Failure(FourSquareError.InvalidJSONData)
            }
            
            var finalVenues = [Venue]()
            for venueJSON in venuesArray {
                if let venue = venueFromJSONObject(venueJSON) {
                    finalVenues.append(venue)
                }
            }
            
            if finalVenues.count == 0 && venuesArray.count > 0 {
                // We weren't able to parse any of the venues
                return .Failure(FourSquareError.InvalidJSONData)
            }
            
            
            return .Success(finalVenues)
        }
        catch let error {
            return .Failure(error)
        }
    }
    
    private static func venueFromJSONObject(json: [String : AnyObject]) -> Venue? {
        guard let
            //RF: With API key values I will generally put into a constants file and just use them all global variables, because typically you will be reusing the same keys in multiple responses.
            id = json["id"] as? String,
            name = json["name"] as? String,
            locationDict = json["location"] as? NSDictionary,
            lat = locationDict["lat"] as? Double,
            long = locationDict["lng"] as? Double
            else {
                
                // Don't have enough information to construct a Venue
                return nil
        }
        
        return Venue(id: id, name: name, coordinate: CLLocationCoordinate2DMake(lat, long))
    }
    
}