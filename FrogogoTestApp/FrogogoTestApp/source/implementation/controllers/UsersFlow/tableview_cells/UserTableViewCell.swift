//
//  UserTableViewCell.swift
//  FrogogoTestApp
//
//  Created by User on 11/22/19.
//  Copyright © 2019 User. All rights reserved.
//

import UIKit

class UserTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var activityLoad: UIActivityIndicatorView!
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        avatarImageView.cornerRadius = avatarImageView.frame.width / 2
    }

}
