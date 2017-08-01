//
//  Date.swift
//  Group-Connect
//
//  Created by Howard Wang on 8/1/17.
//  Copyright © 2017 Howard Wang. All rights reserved.
//

import Foundation

extension Date {
    func timeAgo() -> String {
        let interval = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: self, to: Date())
        
        if let yearsAgo = interval.year, yearsAgo > 0 {
            if yearsAgo == 1 {
                return "1 year ago"
            } else {
                return "\(yearsAgo) years ago"
            }
        } else if let monthsAgo = interval.month, monthsAgo > 0 {
            if monthsAgo == 1 {
                return "1 month ago"
            } else {
                return "\(monthsAgo) months ago"
            }
        } else if let daysAgo = interval.day, daysAgo > 0 {
            if daysAgo == 1 {
                return "1 day ago"
            } else {
                return "\(daysAgo) days ago"
            }
        } else if let hoursAgo = interval.hour, hoursAgo > 0 {
            if hoursAgo == 1 {
                return "1 hour ago"
            } else {
                return "\(hoursAgo) hours ago"
            }
        } else if let minutesAgo = interval.minute, minutesAgo - 1 > 0 {
            if minutesAgo - 1 == 1 {
                return "1 minute ago"
            } else {
                return "\(minutesAgo - 1) minutes ago"
            }
        } else {
            return "just now"
        }
    }
}
