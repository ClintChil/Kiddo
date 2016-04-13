import Foundation

class VenueStore {
    
    let session: NSURLSession = {
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        return NSURLSession(configuration: config)
    }()
    
    func exploreNearbyVenues(lat lat: Double, long: Double, query: String, completion: (VenuesResult) -> Void) {
        let url = FourSquareAPI.exploreVenuesURL(lat: lat, long: long, query: query)
        let request = NSURLRequest(URL: url)
        let task = session.dataTaskWithRequest(request) { (data, response, error) -> Void in
            
            let result = self.processExploreRequest(data: data, error: error)
            completion(result)
        }
        task.resume()
    }
    
    func processExploreRequest(data data: NSData?, error: NSError?) -> VenuesResult {
        guard let jsonData = data else {
            return .Failure(error!)
        }
        return FourSquareAPI.venuesFromJSONData(jsonData) //FIXME: implement new method
    }
    
    func searchNearbyVenues(lat lat: Double, long: Double, query: String, completion: (VenuesResult) -> Void) {
        let url = FourSquareAPI.searchVenuesURL(lat: lat, long: long, query: query)
        let request = NSURLRequest(URL: url)
        let task = session.dataTaskWithRequest(request) { (data, response, error) -> Void in
            
            let result = self.processVenuesRequest(data: data, error: error)
            completion(result)
        }
        task.resume()
    }
    
    func processVenuesRequest(data data: NSData?, error: NSError?) -> VenuesResult {
        guard let jsonData = data else {
            return .Failure(error!)
        }
        return FourSquareAPI.venuesFromJSONData(jsonData)
    }
}