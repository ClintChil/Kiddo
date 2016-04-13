import MapKit
// Forced to import MapKit & Inherit from NSObject because MKAnnotation ☹️

class Venue: NSObject, MKAnnotation {
    let id: String
    let name: String
    let phone: String
    let phoneWithFormat: String
    let coordinate: CLLocationCoordinate2D
    var title: String? { return name }
    var subtitle: String? { return phoneWithFormat }
    
    init(id: String, name: String, phone: String, phoneWithFormat: String, coordinate: CLLocationCoordinate2D) {
        self.id = id
        self.name = name
        self.phone = phone
        self.phoneWithFormat = phoneWithFormat
        self.coordinate = coordinate
    }
}

func == (lhs: Venue, rhs: Venue) -> Bool {
    return lhs.id == rhs.id
}
