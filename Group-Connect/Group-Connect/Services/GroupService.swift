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
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let snapshot = snapshot.children.allObjects as? [DataSnapshot] else {
                return
            }
            
            let groupCodes = snapshot.flatMap { return $0.key }
            print(groupCodes)
            
            var newCode: String?
            var valid = false
            while !valid {
                newCode = randomString()
                valid = checkCode(newCode!, groupCodes)
            }
            
            print("New Group: \(newCode!)\n")
            
            let coordinateDict = [Constants.Location.latitude : User.defaultLocation.coordinate.latitude, Constants.Location.longitude : User.defaultLocation.coordinate.longitude]
            
            let groupData = ["\(newCode!)/\(User.current.uid)" : coordinateDict]
            
            print("Updating Location in Firebase")
            ref.updateChildValues(groupData) { (error, _) in
                if let error = error {
                    assertionFailure(error.localizedDescription)
                }
                User.setGroup(newCode!)
            }
        })
        
    }
    
    private static func randomString() -> String {
        var randomString = ""
        let letters: NSString = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)
        
        for _ in 0 ..< 1 {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        return randomString
    }
    
    private static func checkCode(_ code: String, _ groupCodes: [String]) -> Bool {
        if groupCodes.isEmpty {
            return true
        } else {
            var valid = true
            for groupCode in groupCodes {
                if code == groupCode {
                    print("INVALID\n")
                    valid = false
                    break
                }
            }
            return valid
        }
    }
}
