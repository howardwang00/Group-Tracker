//
//  LocationService.swift
//  Group-Connect
//
//  Created by Howard Wang on 7/27/17.
//  Copyright © 2017 Howard Wang. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase
import GoogleMaps

struct LocationService {
    static func updateLocation(_ currentLocation: CLLocation) {
        guard let groupCode = User.current.groupCode else { return }
        
        let ref = Database.database().reference().child(Constants.groups).child(groupCode).child(User.current.uid)
        let locationDict = [Constants.Location.latitude : currentLocation.coordinate.latitude, Constants.Location.longitude : currentLocation.coordinate.longitude]
        let timestamp = Date().timeIntervalSinceReferenceDate
        let locationInfo = [Constants.Location.timestamp: timestamp, Constants.Location.coordinate: locationDict] as [String : Any]
        
        ref.updateChildValues(locationInfo) { (error, _) in
            if let error = error {
                assertionFailure(error.localizedDescription)
            }
        }
    }
    
    static func startRetrieveGroupLocations(returnObserver: (UInt) -> Void, completion: @escaping ([String: [String: CLLocationDegrees]], [String: String], [String: Date]) -> Void) {
        guard let groupCode = User.current.groupCode else { return }
        let ref = Database.database().reference().child(Constants.groups).child(groupCode)
        let observer = ref.observe(.value, with: { (snapshot) in
            guard let groupInformation = snapshot.value as? [String: [String: Any]] else {
                fatalError("Group Information Does not Exist")
            }
            
            var groupLocations = [String: [String: CLLocationDegrees]]()
            var groupUsernames = [String: String]()
            var groupTimestamps = [String: Date]()
            for userID in groupInformation.keys {
                guard let coordinate = groupInformation[userID]![Constants.Location.coordinate] as? [String: CLLocationDegrees],
                    let username = groupInformation[userID]![Constants.User.username] as? String,
                    let timestamp = groupInformation[userID]![Constants.Location.timestamp] as? TimeInterval
                    else { continue }
                groupLocations[userID] = coordinate
                groupUsernames[userID] = username
                groupTimestamps[userID] = Date(timeIntervalSinceReferenceDate: timestamp)
            }
            completion(groupLocations, groupUsernames, groupTimestamps)
        })
        returnObserver(observer)
    }
}
