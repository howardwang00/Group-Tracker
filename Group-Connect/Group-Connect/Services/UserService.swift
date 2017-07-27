//
//  UserService.swift
//  Group-Connect
//
//  Created by Howard Wang on 7/12/17.
//  Copyright © 2017 Howard Wang. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth.FIRUser

struct UserService {
    static func createUser(_ firebaseUser: FirebaseAuth.User, username: String, completion: @escaping (User?) -> Void) {
        let ref = Database.database().reference().child(Constants.users).child(firebaseUser.uid)
        let userAttributes = [Constants.User.username : username]
        
        ref.setValue(userAttributes) { (error, ref) in
            if let error = error {
                assertionFailure(error.localizedDescription)
                completion(nil)
            }
            
            print("Wrote to Firebase")
            
            let user = User(uid: firebaseUser.uid, username: username)
            completion(user)
        }
    }
}
