//
//  UITextField+Error.swift
//  FrogogoTestApp
//
//  Created by User on 11/24/19.
//  Copyright © 2019 User. All rights reserved.
//

import UIKit

extension UITextField {
    func setState(isValid: Bool) {
        self.borderWidth = isValid ? 0 : 2
        self.borderColor = isValid ? .clear : .red
    }
}
