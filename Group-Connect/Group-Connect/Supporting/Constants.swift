//
//  Constants.swift
//  Group-Connect
//
//  Created by Howard Wang on 7/12/17.
//  Copyright © 2017 Howard Wang. All rights reserved.
//


import Foundation

struct Constants {
    
    static let createUsername = "CreateUsername"
    static let users = "users"
    static let groups = "groups"
    
    struct User {
        static let username = "username"
        static let uid = "uid"
        static let current = "current"
    }
    
    struct Segue {
        static let toGroup = "toGroup"
        static let toMap = "toMap"
    }
    
    struct Location {
        static let latitude = "latitude"
        static let longitude = "longitude"
    }
}
