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
        
        super.init()
    }
}

extension User: NSCoding {
    func encode(with aCoder: NSCoder) {
        aCoder.encode(uid, forKey: Constants.User.uid)
        aCoder.encode(username, forKey: Constants.User.username)
    }
}
