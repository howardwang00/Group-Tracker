//
//  UserService.swift
//  Group-Connect
//
//  Created by Howard Wang on 7/12/17.
//  Copyright © 2017 Howard Wang. All rights reserved.
//

import Foundation
import FirebaseDatabase

struct UserService {
    
    static func createUser(username: String, completion: @escaping (User?) -> Void) {
        let ref = Database.database().reference().child(Constants.users)
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard var userArray = snapshot.value as? [String] else { return }
            
            for user in userArray {
                if user == username {
                    return
                }
            }
            userArray.append(username)
            ref.setValue(userArray) { (error, ref) in
                if let error = error {
                    assertionFailure(error.localizedDescription)
                    completion(nil)
                }
            }
            let user = User(snapshot: snapshot)
            completion(user)
        })
        
    }
}
