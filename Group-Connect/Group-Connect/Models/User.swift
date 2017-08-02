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
    var username: String
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
        print("Set current groupCode to \(groupCode ?? "nil")")
    }
    
    static func setUsername(_ username: String) {
        current.username = username
        
        let data = NSKeyedArchiver.archivedData(withRootObject: User.current)
        UserDefaults.standard.set(data, forKey: Constants.User.current)
        print("Set current username to \(username)")
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
