import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UITextFieldDelegate {
    
    var store: VenueStore!
    var venues = [Venue]()
    let locationManager = CLLocationManager()
    
    @IBOutlet private var mapView: MKMapView!
    
    // MARK: - UIViewController
    
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
    
    // MARK: - CLLocationManager Delegate
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("didUpdateLocations")
        loadSearchResults("pizza")
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print(error)
    }
    
    @IBAction func onReloadButtonPressed(sender: AnyObject) {
        loadSearchResults("pizza")
    }
    
    func updateMapRegion() {
        let mapRegion = MKCoordinateRegion(center: self.mapView.userLocation.coordinate, span: MKCoordinateSpanMake(0.35, 0.35))
        self.mapView.setRegion(mapRegion, animated: true)
        
    }
    // MARK: - MapView
    
    private func customizeMapView() {
        mapView.showsUserLocation = true
        mapView.showsCompass = true
        mapView.showsPointsOfInterest = false
        mapView.setUserTrackingMode(MKUserTrackingMode.Follow, animated: true)
    }
    
    // Show map scale while zooming map
    func mapView(mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
    // FIXME: disable scale on pan map
        mapView.showsScale = true
    }
    
    func mapView(mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        mapView.showsScale = false
//        // update search results if map view change
//        loadSearchResults("pizza")
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
            
            let button = UIButton(type: .InfoLight)
            button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
            view.rightCalloutAccessoryView = button
            
            return view
        }
        return nil
    }
    
    
    // FIXME: add segue to detailview
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if let venue = view.annotation as? Venue {
            print(venue.name)
        }
    }
    
    // MARK: - Helper Methods
    
    private func loadSearchResults(query: String) {
        store.fetchNearbyVenues(lat: mapView.region.center.latitude, long: mapView.region.center.longitude, query: query) { (venuesResult) -> Void in
            NSOperationQueue.mainQueue().addOperationWithBlock {
                switch venuesResult {
                    
                case let .Success(venues):
                    print("Successfullly found \(venues.count) venues.")
                    self.venues = venues
                    
                    // FIXME: don't annotate map on load search method
                    // add annotations to map
                    self.mapView.removeAnnotations(self.mapView.annotations)
                    self.mapView.addAnnotations(self.venues)
                    
                case let .Failure(error):
                    print("Error fetching venues: \(error)")
                    print(error)
                }
            }
        }
    }
}