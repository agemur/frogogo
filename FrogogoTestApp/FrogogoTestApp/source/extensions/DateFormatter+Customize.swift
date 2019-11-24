//
//  DateFormatter+Customize.swift
//  FrogogoTestApp
//
//  Created by User on 11/22/19.
//  Copyright © 2019 User. All rights reserved.
//

import Foundation

extension DateFormatter {
    
    static var RFC3339DateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter
    }
    
}
