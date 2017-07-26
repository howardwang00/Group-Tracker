//
//  Storyboard.swift
//  Group-Connect
//
//  Created by Howard Wang on 7/14/17.
//  Copyright © 2017 Howard Wang. All rights reserved.
//

import UIKit

extension UIStoryboard {
    enum MGType: String {
        case createUsername
        case main
        var filename: String {
            return rawValue.capitalized
        }
    }
    
    convenience init(type: MGType, bundle: Bundle? = nil) {
        self.init(name: type.filename, bundle: bundle)
    }
    
    static func initialViewController(for type: MGType) -> UIViewController {
        let storyboard = UIStoryboard(type: type)
        guard let initalViewController = storyboard.instantiateInitialViewController() else {
            fatalError("Couldn't instantiate initial view controller for \(type.filename) storyboard")
        }
        return initalViewController
    }
}
