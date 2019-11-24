//
//  UIView+Inspectable.swift
//  FrogogoTestApp
//
//  Created by User on 11/22/19.
//  Copyright © 2019 User. All rights reserved.
//

import UIKit


extension UIView {
    var allSubViews: [UIView] {
        var array = [self.subviews].flatMap { $0 }
        array.forEach { array.append(contentsOf: $0.allSubViews) }
        return array
    }

    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            maskToBounds = true
        }
    }

    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }

    @IBInspectable var borderColor: UIColor {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue.cgColor
        }
    }

    @IBInspectable var maskToBounds: Bool {
        get {
            return layer.masksToBounds
        }
        set {
            layer.masksToBounds = newValue
        }
    }
}
