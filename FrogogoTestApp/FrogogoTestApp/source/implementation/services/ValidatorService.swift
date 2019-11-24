//
//  ValidatorService.swift
//  FrogogoTestApp
//
//  Created by User on 11/24/19.
//  Copyright © 2019 User. All rights reserved.
//

import Foundation

enum ValidationType: String {
    case name = "[0-9a-zA-Z]{2,}"
    case email = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    case url = "((?:http|https)://)?(?:www\\.)?[\\w\\d\\-_]+\\.\\w{2,3}(\\.\\w{2})?(/(?<=/)(?:[\\w\\d\\-./_]+)?)?"
}

class ValidatorService {
    static func isValid(_ text: String?, type: ValidationType) -> Bool {
        guard let text = text else { return false }
        return NSPredicate(format:"SELF MATCHES %@", type.rawValue).evaluate(with: text)
    }
}
