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
    
    var spotStore: SpotStore!
    let locationManager = CLLocationManager()
    @IBOutlet var locateMeButton: UIButton!
    @IBOutlet var mapView: MKMapView!
    
    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // configure mapView
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.showsCompass = true
        mapView.showsPointsOfInterest = false
        
        locationManager.delegate = self
        
        // Request Authorization to use location
        if CLLocationManager.authorizationStatus() == .NotDetermined {
            locationManager.requestWhenInUseAuthorization()
        }
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        centerMapOnUser(animated: false)
    }
    
    @IBAction func onLocateMeButtonPressed(sender: UIButton) {
        centerMapOnUser()
    }
    
    @IBAction func onReloadSearchButtonPressed(sender: UIButton) {
        loadPizzaResults()
    }
    
    // MARK: - CLLocationManager Delegate
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedWhenInUse || status == .AuthorizedAlways {
            manager.startUpdatingLocation()
            
        }
    }
    
    // MARK: - MapView Delegate
    
    func mapView(mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        
//        // hide the locateMe button while the user's location is in view
//        if mapView.userLocation.location != nil && mapView.userLocationVisible == true {
//            locateMeButton.hidden = true
//        } else {
//            locateMeButton.hidden = false
//        }
    }
    
    // MARK: - Helper Methods
    
    func centerMapOnUser(animated animated: Bool = true) {
        if let userLocation = locationManager.location?.coordinate {
            mapView.setRegion(MKCoordinateRegionMake(userLocation, MKCoordinateSpanMake(0.02, 0.02)), animated: animated)
        }
    }
    
    func loadPizzaResults() {
        let searchRequest = MKLocalSearchRequest()
        searchRequest.naturalLanguageQuery = "Pizza"
        searchRequest.region = mapView.region
        
        let search = MKLocalSearch.init(request: searchRequest)
        
        search.startWithCompletionHandler { (response, error) in
            if let mapItems = response?.mapItems {
                var placemarks = [MKPlacemark]()
                for item in mapItems {
                    // print description of mapItem
                    print(item)
                    placemarks.append(item.placemark)
                    
                }
                self.mapView.removeAnnotations(self.mapView.annotations)
                self.mapView.addAnnotations(placemarks)
            
            }
            else {
                print(error)
            }
        }

    }
    
    
}

