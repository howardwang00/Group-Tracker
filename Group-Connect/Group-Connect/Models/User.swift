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
    let uid: String
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
            //let data = NSKeyedArchiver
        }
    }
    
    init(uid: String, username: String) {
        self.uid = uid
        self.username = username
        
        super.init()
    }
    
    init?(snapshot: DataSnapshot) {
        guard let dict = snapshot.value as? [String : Any],
            let username = dict[Constants.UserDefaults.username] as? String
        else { return nil }
        
        self.uid = snapshot.key
        self.username = username
        
        super.init()
    }
    
}
