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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    override func loadView() {
        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 6.0)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        view = mapView
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: -33.86, longitude: 151.20)
        marker.title = "Sidney"
        marker.snippet = "Australia"
        marker.map = mapView
        
    }
    
}
