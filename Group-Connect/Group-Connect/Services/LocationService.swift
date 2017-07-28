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
        
        ref.updateChildValues(locationDict) { (error, _) in
            if let error = error {
                assertionFailure(error.localizedDescription)
            }
        }
    }
    
    static func startRetrieveGroupLocations(returnObserver: (UInt) -> Void, completion: @escaping ([String: [String: CLLocationDegrees]]) -> Void) {
        guard let groupCode = User.current.groupCode else { return }
        let ref = Database.database().reference().child(Constants.groups).child(groupCode)
        let observer = ref.observe(.value, with: { (snapshot) in
            guard let groupDict = snapshot.value as? [String: [String: CLLocationDegrees]] else {
                fatalError("Group Information Does not Exist")
            }
            completion(groupDict)
        })
        returnObserver(observer)
    }
}
