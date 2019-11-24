
//
//  UsersRepository.swift
//  FrogogoTestApp
//
//  Created by User on 11/24/19.
//  Copyright © 2019 User. All rights reserved.
//

import Foundation

class UserRepository: BaseRepository<UserModel> {
    override func addItem(item: UserModel, by index: Int? = nil) {
        let index = items?.firstIndex(where: {$0.id == item.id})
        super.addItem(item: item, by: index)
    }
}
