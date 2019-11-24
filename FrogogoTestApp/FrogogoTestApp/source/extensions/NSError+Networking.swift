//
//  NSError+Networking.swift
//  FrogogoTestApp
//
//  Created by User on 11/22/19.
//  Copyright © 2019 User. All rights reserved.
//

import Foundation

extension NSError {
    static var undefinedServerError = NSError(domain: "Undefined server error", code: 100, userInfo: nil)
    static var internalServerError = NSError(domain: "Server error", code: 100, userInfo: nil)
    static var serverDataError = NSError(domain: "Server data error", code: 101, userInfo: nil)
}
