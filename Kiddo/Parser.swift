import Foundation
import MapKit

typealias JSONDictionary = [String:AnyObject]

class Parser {
    func parseDictionary(data: NSData?) -> JSONDictionary? {
        do {
            if let data = data, json = try NSJSONSerialization.JSONObjectWithData(data, options: []) as? JSONDictionary {
                return json
            }
        } catch {
            print("Couldn't parse JSON. Error: \(error)")
        }
        return nil
    }
    
    func venuesFromSearchResponse(data: NSData?) -> [Venue]? {
        guard let dict = parseDictionary(data) else {
            print("Error: couldn't parse dictionary from data")
            return nil
        }
        
        guard let venueDicts = dict["items"] as? [JSONDictionary] else {
            print("Error: couldn't parse items from JSON: \(dict)")
            return nil
        }
        
        return venueDicts.flatMap { venueFromJSONObject ($0) }
    }
    
    func venueFromJSONObject(json: JSONDictionary) -> Venue? {
        if let
            id = json["id"] as? String,
            name = json["name"] as? String,
            contact = json["contact"] as? JSONDictionary,
            phone = contact["phone"] as? String,
            formattedPhone = contact["formattedPhone"] as? String,
            locationDict = json["location"] as? JSONDictionary,
            lat = locationDict["lat"] as? Double,
            long = locationDict["lng"] as? Double {
            let venue = Venue(id: id, name: name, phone: phone, phoneWithFormat: formattedPhone, coordinate: CLLocationCoordinate2DMake(lat, long))
            return venue
        } else {
            // Don't have enough information to construct a Venue
            return nil
        }
    }
}