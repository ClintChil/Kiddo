import MapKit

// ☹️ Forced to import MapKit & Inherit from NSObject because MapKit

class Venue: NSObject, MKAnnotation {
    
    let id: String
    let name: String
    let coordinate: CLLocationCoordinate2D
    var title: String? { return name }
//    var subtitle: String? { return name }
    
    
    init(id: String, name: String, coordinate: CLLocationCoordinate2D) {
        self.id = id
        self.name = name
        self.coordinate = coordinate
    }
}

