//
//  User.swift
//  Group-Connect
//
//  Created by Howard Wang on 7/13/17.
//  Copyright © 2017 Howard Wang. All rights reserved.
//

import Foundation
import FirebaseDatabase.FIRDataSnapshot
import GoogleMaps

class User: NSObject {
    let uid: String
    let username: String
    var currentLocation: CLLocation?
    var groupCode: String?
    
    // A default location to use when location permission is not granted.
    static let defaultLocation = CLLocation(latitude: -33.869405, longitude: 151.199)
    
    private static var _current: User?
    
    static var current: User {
        guard let currentUser = _current else {
            fatalError("Current user does not exist")
        }
        return currentUser
    }
    
    static func setCurrent(_ user: User, writeToUserDefaults: Bool = false) {
        if writeToUserDefaults {
            let data = NSKeyedArchiver.archivedData(withRootObject: user)
            UserDefaults.standard.set(data, forKey: Constants.User.current)
            print("Set current user in UserDefaults")
        }
        _current = user
    }
    
    static func setGroup(_ groupCode: String?) {
        current.groupCode = groupCode
        
        let data = NSKeyedArchiver.archivedData(withRootObject: User.current)
        UserDefaults.standard.set(data, forKey: Constants.User.current)
        print("Set current groupCode \(groupCode ?? "nil")")
    }
    
    static func updateLocation(_ location: CLLocation) {
        current.currentLocation = location
        
        guard let currentLocation = current.currentLocation,
            let groupCode = current.groupCode else { return }
        
        //print("Updating location in firebase")
        let ref = Database.database().reference().child(Constants.groups).child(groupCode).child(current.uid)
        let locationDict = [Constants.Location.latitude : currentLocation.coordinate.latitude, Constants.Location.longitude : currentLocation.coordinate.longitude]
        
        ref.updateChildValues(locationDict) { (error, _) in
            if let error = error {
                assertionFailure(error.localizedDescription)
            }
        }
    }
    
    init(uid: String, username: String) {
        self.uid = uid
        self.username = username
        
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        guard let uid = aDecoder.decodeObject(forKey: Constants.User.uid) as? String,
            let username = aDecoder.decodeObject(forKey: Constants.User.username) as? String
            else { return nil }
        
        self.uid = uid
        self.username = username
        
        if let groupCode = aDecoder.decodeObject(forKey: Constants.User.groupCode) as? String {
            self.groupCode = groupCode
        }
        
        super.init()
    }
}

extension User: NSCoding {
    func encode(with aCoder: NSCoder) {
        aCoder.encode(uid, forKey: Constants.User.uid)
        aCoder.encode(username, forKey: Constants.User.username)
        aCoder.encode(groupCode, forKey: Constants.User.groupCode)
    }
}
