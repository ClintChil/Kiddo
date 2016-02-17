import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UITextFieldDelegate {
    
    var store: VenueStore!
    var venues = [Venue]()
    let locationManager = CLLocationManager()
    
    @IBOutlet private var locateMeButton: UIButton!
    @IBOutlet private var mapView: MKMapView!
    @IBOutlet var searchTextField: UITextField!
    
    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // configure locationManager and request authorization
        locationManager.delegate = self
        if CLLocationManager.authorizationStatus() == .NotDetermined {
            locationManager.requestWhenInUseAuthorization()
        }
        
        // configure mapView
        mapView.delegate = self
        customizeMapView()
        
        // add gesture recognizer to dismiss keyboard
        let tapGesture = UITapGestureRecognizer(target: self, action: "handleTap:")
        mapView.addGestureRecognizer(tapGesture)
    }
    
    func handleTap(tapGesture: UITapGestureRecognizer) {
        searchTextField.resignFirstResponder()
    }
    
    // MARK: - IBActions
    
    @IBAction func onLocateMeButtonPressed(sender: UIButton) {
        mapView.setUserTrackingMode(.Follow, animated: true)
    }
    
    @IBAction func onReloadSearchButtonPressed(sender: UIButton) {
        loadSearchResults("Pizza")
    }
    
    // MARK: - CLLocationManager Delegate
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedWhenInUse || status == .AuthorizedAlways {
            manager.startUpdatingLocation()   
        }
    }
    
    // MARK: - MapView
    
    private func customizeMapView() {
        mapView.showsUserLocation = true
        mapView.showsCompass = true
        mapView.showsPointsOfInterest = false
    }
    
    // Show map scale while zooming map
    func mapView(mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
    // FIXME: disable scale on pan map
        mapView.showsScale = true
    }
    
    func mapView(mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
    
        mapView.showsScale = false
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
    
    // MARK: - Text Field
    
    func textFieldDidEndEditing(textField: UITextField) {
        if let searchText = textField.text {
            if searchText != "" {
                loadSearchResults(searchText)
            }
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()

        return true
    }
    
    // MARK: - Helper Methods
    
    private func loadSearchResults(query: String) {
        
        store.fetchNearbyVenues(lat: mapView.region.center.latitude, long: mapView.region.center.longitude, query: query) { (venuesResult) -> Void in
            NSOperationQueue.mainQueue().addOperationWithBlock {
                switch venuesResult {
                    
                case let .Success(venues):
                    print("Successfullly found \(venues.count) venues.")
                    self.venues = venues
                    
                case let .Failure(error):
                    print("Error fetching venues: \(error)")
                    print(error)
                }
                
                // add annotations to map
                self.mapView.removeAnnotations(self.mapView.annotations)
                self.mapView.addAnnotations(self.venues)
            }
        }
    }
    
    
}

