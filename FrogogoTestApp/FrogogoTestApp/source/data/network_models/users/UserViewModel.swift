//
//  UserViewModel.swift
//  FrogogoTestApp
//
//  Created by User on 11/24/19.
//  Copyright © 2019 User. All rights reserved.
//

import Foundation

struct UserViewModel {
    let firstName: String
    let lastName: String
    let email: String
    let avatarURL: URL?
    
    static func generateViewModel(changedUser: CreateUserModel?, user: UserModel?) -> UserViewModel {
        return UserViewModel(
            firstName: changedUser?.firstName ?? user?.firstName ?? "",
            lastName: changedUser?.lastName ?? user?.lastName ?? "",
            email: changedUser?.email ?? user?.email ?? "",
            avatarURL: changedUser?.avatarURL ?? user?.avatarURL)
    }
}
