import Foundation

enum VenueError: ErrorType {
    case ImageCreationError
}

class VenueStore {
    
    let session: NSURLSession = {
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        return NSURLSession(configuration: config)
    }()
    
    func fetchNearbyVenues(lat: Double, long: Double, query: String, completion: (VenuesResult) -> Void) {
        let url = FourSquareAPI.searchVenuesURL(lat: lat, long: long, query: query)
        let request = NSURLRequest(URL: url)
        let task = session.dataTaskWithRequest(request) { (data, response, error) -> Void in
            
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