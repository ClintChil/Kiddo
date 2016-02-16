//
//  MapViewController.swift
//  Kiddo
//
//  Created by Clint Chilcott on 2/11/16.
//  Copyright © 2016 Clint Chilcott. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    var store: VenueStore!
    let locationManager = CLLocationManager()
    
    @IBOutlet var locateMeButton: UIButton!
    @IBOutlet var mapView: MKMapView!
    
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
        
//        // Load results for Pizza on load
//        loadSearchResults("Pizza")
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        centerMapOnUser(animated: false)
    }
    
    // MARK: - IBActions
    
    @IBAction func onLocateMeButtonPressed(sender: UIButton) {
        centerMapOnUser()
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
    
    
    func customizeMapView() {
        
        mapView.showsUserLocation = true
        mapView.showsCompass = true
        mapView.showsPointsOfInterest = false
    }
    
    // Show map scale while zooming map
    // FIXME: disable scale on pan map
    func mapView(mapView: MKMapView, regionWillChangeAnimated animated: Bool) {

        mapView.showsScale = true
    }
    
    func mapView(mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
    
        mapView.showsScale = false
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation.isKindOfClass(MKUserLocation) { return nil }
        
        let annotationView = MKPinAnnotationView()
        annotationView.pinTintColor = UIColor.init(red: 0.0/255.0, green: 169.0/255.0, blue: 120.0/255.0, alpha: 255.0/255.0)
        return annotationView
    }
    
    
    // MARK: - Helper Methods
    
    func centerMapOnUser(animated animated: Bool = true) {
        if let userLocation = locationManager.location?.coordinate {
            mapView.setRegion(MKCoordinateRegionMake(userLocation, MKCoordinateSpanMake(0.02, 0.02)), animated: animated)
        }
    }
    
    func loadSearchResults(query: String) {
        
        store.fetchNearbyVenues(coordinate: mapView.userLocation.coordinate, query: query) { (venuesResult) -> Void in
            NSOperationQueue.mainQueue().addOperationWithBlock {
                switch venuesResult {
                    
                case let .Success(venues):
                    print("Successfullly found \(venues.count) venues.")
                    self.store.venues = venues
                    
                case let .Failure(error):
                    print("Error fetching venues: \(error)")
                    print(error)
                }
                
                // add annotations to map
                self.mapView.removeAnnotations(self.mapView.annotations)
                self.mapView.showAnnotations(self.store.venues, animated: true)
                
            }
            
        }

        
    }
    
    
}

