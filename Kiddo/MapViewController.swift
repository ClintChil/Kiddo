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
                self.mapView.addAnnotations(self.store.venues)
                self.mapView.showAnnotations(self.mapView.annotations, animated: true)
            }
            
        }

        
    }
    
    
}

