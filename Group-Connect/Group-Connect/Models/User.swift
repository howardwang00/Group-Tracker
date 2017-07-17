//
//  User.swift
//  Group-Connect
//
//  Created by Howard Wang on 7/13/17.
//  Copyright © 2017 Howard Wang. All rights reserved.
//

import Foundation
import FirebaseDatabase.FIRDataSnapshot

class User: NSObject {
    let username: String
    
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
        }
    }
    
    init(uid: String, username: String) {
        self.username = username
        
        super.init()
    }
    
    init?(snapshot: DataSnapshot) {
        guard let username = snapshot.value as? String
            else { return nil }
        
        self.username = username
        
        super.init()
    }
    
}
