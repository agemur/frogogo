//
//  ReuseIdentifiers.swift
//  FrogogoTestApp
//
//  Created by User on 11/22/19.
//  Copyright © 2019 User. All rights reserved.
//

import UIKit


protocol ReuseIdentifierProtocol {
    static var reuseIdentifier: String { get }
}

extension UITableViewCell: ReuseIdentifierProtocol {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
