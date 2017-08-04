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
    let marker: GMSMarker
    var meetupTime: Date?
    let dateFormatter = DateFormatter()
    
    init(coordinate: CLLocationCoordinate2D, mapView: GMSMapView) {
        self.marker = GMSMarker(position: coordinate)
        self.marker.appearAnimation = .pop
        self.marker.map = mapView
        
        dateFormatter.timeStyle = .short
    }
    
    convenience init(creator: String, title: String, meetupTime: Date, coordinate: CLLocationCoordinate2D, mapView: GMSMapView) {
        self.init(coordinate: coordinate, mapView: mapView)
        confirmMeetup(creator: creator, title: title, meetupTime: meetupTime)
    }
    
    func confirmMeetup(creator: String = User.current.username, title: String, meetupTime: Date) {
        self.marker.title = title
        self.marker.snippet = "Creator: \(creator)\nMeet at: \(dateFormatter.string(from: meetupTime))"
        self.meetupTime = meetupTime
        self.marker.isDraggable = false
    }
    
    func updateLocation(coordinate: CLLocationCoordinate2D) {
        marker.position = coordinate
    }
}

