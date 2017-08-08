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
    var groupObserver: UInt?
    
    var groupMarkers = [String: GMSMarker]()
    let markerIcon = UIImage(named: Constants.markerIcon)!.withRenderingMode(.alwaysTemplate)
    var groupTimestamps = [String: Date]()
    
    var timer: Timer?
    
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
        
        print("Retrieve Group Locations")
        LocationService.startRetrieveGroupLocations(returnObserver: { (observer) in
            groupObserver = observer
        }) { (groupLocations, groupUsernames, groupTimestamps) in
            print("Retrieved Group Locations")
            
            self.updateGroupLocations(groupLocations)
            self.groupTimestamps = groupTimestamps
            self.setMarkerUsernames(groupUsernames)
        }
        
        view.addSubview(mapView)
        mapView.isHidden = true //hides until location is updated
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateGroupTimestamps), userInfo: nil, repeats: true)
        
        super.viewDidLoad()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer?.invalidate()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    @IBAction func leaveGroupButtonTapped(_ sender: Any) {
        let alertController = UIAlertController(title: "Leave Group Confirmation", message: "Are you sure you want to leave your group?", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Leave", style: UIAlertActionStyle.destructive, handler: { action in
            GroupService.leaveGroup(observer: self.groupObserver)
            self.performSegue(withIdentifier: Constants.Segue.leaveGroup, sender: nil)
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func updateGroupLocations(_ groupLocations: [String: [String: CLLocationDegrees]]) {
        print(groupLocations)
        for userID in groupMarkers.keys {
            if groupLocations[userID] == nil {
                if groupMarkers[userID] != nil {
                    groupMarkers[userID]!.map = nil
                    groupMarkers[userID] = nil
                }
            }
        }
        
        for userID in groupLocations.keys {
            if userID == User.current.uid {
                print("Found current user")
                continue
            }
            
            guard let latitude = groupLocations[userID]?[Constants.Location.latitude],
                let longitude = groupLocations[userID]?[Constants.Location.longitude]
                else { return }
            
            print("Updating a member position")
            
            if groupMarkers[userID] == nil {
                groupMarkers[userID] = GMSMarker()
                groupMarkers[userID]!.appearAnimation = GMSMarkerAnimation.pop
                
                let markerView = UIImageView(image: markerIcon)
                markerView.tintColor = UIColor(blueTint: .medDark)
                groupMarkers[userID]!.iconView = markerView
                groupMarkers[userID]!.groundAnchor = CGPoint(x: 0.5, y: 0.5)
                
                groupMarkers[userID]!.map = self.mapView
            }
            groupMarkers[userID]!.position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        }
    }
    
    private func setMarkerUsernames(_ groupUsernames: [String: String]) {
        for userID in groupUsernames.keys {
            guard let marker = groupMarkers[userID] else { continue }
            marker.title = groupUsernames[userID]
        }
    }
    
    func updateGroupTimestamps() {
        for userID in groupTimestamps.keys {
            guard let marker = groupMarkers[userID],
                let timestamp = groupTimestamps[userID]
                else { continue }
            marker.snippet = "Updated \(timestamp.timeAgo())"
        }
    }
    
}

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation = locations.last!
        
        LocationService.updateLocation(location)
        
        if mapView.isHidden {
            mapView.isHidden = false
            mapView.camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude, longitude: location.coordinate.longitude, zoom: zoomLevel)
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




