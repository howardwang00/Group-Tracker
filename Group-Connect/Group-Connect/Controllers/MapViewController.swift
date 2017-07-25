//
//  MapViewController.swift
//  Group-Connect
//
//  Created by Howard Wang on 7/19/17.
//  Copyright © 2017 Howard Wang. All rights reserved.
//

import UIKit
import GoogleMaps

class MapViewController: UIViewController {
    
    var locationManager = CLLocationManager()
    var groupCode = ""
    var mapView: GMSMapView!
    var zoomLevel: Float = 15.0
    
    override func viewDidLoad() {
        self.title = "Group Code: \(groupCode)"
        
        //initialize the location manager
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.distanceFilter = 50
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
        
        
        let camera = GMSCameraPosition.camera(withLatitude: User.defaultLocation.coordinate.latitude, longitude: User.defaultLocation.coordinate.longitude, zoom: zoomLevel)
        mapView = GMSMapView.map(withFrame: view.bounds, camera: camera)
        mapView.settings.myLocationButton = true
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.isMyLocationEnabled = true
        
        view.addSubview(mapView)
        mapView.isHidden = true //hides until location is updated
        
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation = locations.last!
        //print("Current Location: \(location)")
        
        //Update Current Location
        User.updateLocation(location)
        
        let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude, longitude: location.coordinate.longitude, zoom: zoomLevel)
        
        if mapView.isHidden {
            mapView.isHidden = false
            mapView.camera = camera
        } else {
            mapView.animate(to: camera)
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted:
            print("Location access was restricted.")
        case .denied:
            print("User denied access to location")
            mapView.isHidden = false    //display the map with the default location
        case .notDetermined:
            print("Location status not determined")
        case .authorizedAlways: fallthrough
        case .authorizedWhenInUse:
            print("Location status is OK.")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
        print("Error: \(error)")
    }
}


