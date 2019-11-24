//
//  UIViewController.swift
//  FrogogoTestApp
//
//  Created by User on 11/22/19.
//  Copyright © 2019 User. All rights reserved.
//

import UIKit

extension UIViewController {
    func showAlert(
        title: String? = nil,
        message: String? = nil,
        actions: [UIAlertAction] = [],
        style: UIAlertController.Style = .alert) {
        
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: style)
            if actions.count > 0 {
                for action in actions {
                    alert.addAction(action)
                }
            } else {
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            }
            
            self.present(alert, animated: true, completion: {
                print("alert created")
            })
            }
    }
}
