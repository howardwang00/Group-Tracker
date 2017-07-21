//
//  GroupService.swift
//  Group-Connect
//
//  Created by Howard Wang on 7/20/17.
//  Copyright © 2017 Howard Wang. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth.FIRUser
import FirebaseDatabase

struct GroupService {
    
    static func createGroup() {
        let ref = Database.database().reference().child(Constants.groups)
        
        let groupCode = randomGroupCode()
        print("New Group: \(groupCode)")
        
        let coordinateDict = [Constants.Location.latitude : User.defaultLocation.coordinate.latitude, Constants.Location.longitude : User.defaultLocation.coordinate.longitude]
        
        let groupData = ["\(groupCode)/\(User.current.uid)" : coordinateDict]
        
        ref.updateChildValues(groupData) { (error, _) in
            if let error = error {
                assertionFailure(error.localizedDescription)
            }
            User.setGroup(groupCode)
        }
        
    }
    
    private static func randomGroupCode() -> String {
        var valid = false
        let ref = Database.database().reference().child(Constants.groups)
        var groupCodes = [String]()
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let snapshot = snapshot.children.allObjects as? [DataSnapshot] else {
                return
            }
            
            groupCodes = snapshot.flatMap { return $0.key }
            print(groupCodes)
            
        })
        
        var randomString = ""
        repeat {
            let letters: NSString = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
            let len = UInt32(letters.length)
        
            for _ in 0 ..< 4 {
                let rand = arc4random_uniform(len)
                var nextChar = letters.character(at: Int(rand))
                randomString += NSString(characters: &nextChar, length: 1) as String
            }
            
            if groupCodes.isEmpty {
                valid = true
            } else {
                for groupCode in groupCodes {
                    if randomString == groupCode {
                        break
                    }
                    valid = true
                }
            }
            
        } while (valid == false)
        return randomString
    }
}
