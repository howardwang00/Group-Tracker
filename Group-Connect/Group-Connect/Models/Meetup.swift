//
//  Meetup.swift
//  Group-Connect
//
//  Created by Howard Wang on 8/3/17.
//  Copyright © 2017 Howard Wang. All rights reserved.
//

import UIKit
import GoogleMaps

class Meetup {
    let marker = GMSMarker()
    let creator: String
    let meetupTime: Date
    let dateFormatter = DateFormatter()
    
    init(title: String, meetupTime: Date, position: CLLocationCoordinate2D, mapView: GMSMapView) {
        dateFormatter.timeStyle = .short
        
        self.creator = User.current.username
        self.meetupTime = meetupTime
        
        self.marker.position = position
        self.marker.appearAnimation = .pop
        self.marker.title = title
        self.marker.snippet = "Creator: \(creator)\nMeet at: \(dateFormatter.string(from: meetupTime))"
        
        self.marker.map = mapView
    }
}

