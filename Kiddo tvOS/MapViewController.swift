import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UITextFieldDelegate {

    var store: VenueStore!
    var venues = [Venue]()
    let locationManager = CLLocationManager()
    
    @IBOutlet private var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // configure locationManager and request authorization
        locationManager.delegate = self
        
        if CLLocationManager.locationServicesEnabled() {
            if CLLocationManager.authorizationStatus() == .NotDetermined {
                locationManager.requestWhenInUseAuthorization()
            } else if CLLocationManager.authorizationStatus() == .AuthorizedWhenInUse || CLLocationManager.authorizationStatus() == .AuthorizedAlways {
                locationManager.requestLocation()
            }
        }
        
        // configure mapView
        mapView.delegate = self
        customizeMapView()
    }
    
    override func viewDidAppear(animated: Bool) {
        loadSearchResults("pizza")
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("didUpdateLocations")
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print(error)
    }

    private func customizeMapView() {
        mapView.showsUserLocation = true
        mapView.showsPointsOfInterest = false
    }
    
    private func updateAnnotations() {
        // add annotations to map
        self.mapView.removeAnnotations(self.mapView.annotations)
        self.mapView.addAnnotations(self.venues)
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if  let annotation = annotation as? Venue {
            let identifier = "pin"
            let view: MKPinAnnotationView
            if let dequeuedView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier) as? MKPinAnnotationView {
                dequeuedView.annotation = annotation
                view = dequeuedView
            } else {
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            }
            view.canShowCallout = true
            // FIXME: make an extension on UIColor for key colors
            view.pinTintColor = UIColor.init(red: 0.0/255.0, green: 169.0/255.0, blue: 120.0/255.0, alpha: 255.0/255.0)
            
//            let button = UIButton(type: .InfoLight)
//            button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
//            view.rightCalloutAccessoryView = button
            
            return view
        }
        return nil
    }
    
    private func loadSearchResults(query: String) {
        store.fetchNearbyVenues(lat: (locationManager.location?.coordinate.latitude)!, long: (locationManager.location?.coordinate.longitude)!, query: query) { (venuesResult) -> Void in
            NSOperationQueue.mainQueue().addOperationWithBlock {
                switch venuesResult {
                    
                case let .Success(venues):
                    print("Successfullly found \(venues.count) venues.")
                    self.venues = venues
                    
                    self.updateAnnotations()
                    
                case let .Failure(error):
                    print("Error fetching venues: \(error)")
                    print(error)
                }
                
                
            }
        }
    }
    
    override func pressesBegan(presses: Set<UIPress>, withEvent event: UIPressesEvent?) {
        for item in presses {
            if item.type == .UpArrow {
                self.view.backgroundColor = UIColor.greenColor()
            }
        }
    }

}

