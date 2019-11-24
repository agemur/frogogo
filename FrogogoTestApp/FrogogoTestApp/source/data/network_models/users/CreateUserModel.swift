//
//  CreateUserModel.swift
//  FrogogoTestApp
//
//  Created by User on 11/24/19.
//  Copyright © 2019 User. All rights reserved.
//

import Foundation

struct CreateUserWrapper: Encodable {
    var user: CreateUserModel
}

struct CreateUserModel: Encodable {
    static let newUser = -1
    
    let id: Int
    var firstName: String?
    var lastName: String?
    var email: String?
    
    var avatarStr: String?
    
    init(id: Int = newUser,
        firstName: String? = nil,
        lastName: String? = nil,
        email: String? = nil
    ) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
    }
    
    var avatarURL: URL? {
        return URL(string: avatarStr ?? "")
    }

    func isValid(
        for keys: [CodingKeys] = CodingKeys.allCases,
        canBeNil: Bool = false
    ) -> [CodingKeys: Bool] {
        
        var result = [CodingKeys: Bool]()
        for element in keys {
            switch element {
            case .firstName:
                guard !canBeNil, firstName == nil else { continue }
                result[.firstName] = ValidatorService.isValid(firstName, type: .name)
            case .lastName:
                guard !canBeNil, lastName == nil else { continue }
                result[.lastName] = ValidatorService.isValid(lastName, type: .name)
            case .email:
                guard !canBeNil, email == nil else { continue }
                result[.email] = ValidatorService.isValid(email, type: .email)
            case .avatarStr:
                guard let avatarStr = avatarStr, avatarStr != "" else {continue}
                result[.avatarStr] = ValidatorService.isValid(avatarStr, type: .url)
            }
        }
        return result
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(firstName, forKey: .firstName)
        try container.encodeIfPresent(lastName, forKey: .lastName)
        try container.encodeIfPresent(email, forKey: .email)

        try container.encodeIfPresent(avatarStr, forKey: .avatarStr)
    }
    
    enum CodingKeys: String, CodingKey, CaseIterable {
        case firstName = "first_name"
        case lastName = "last_name"
        case email = "email"
        case avatarStr = "avatar_url"
    }
}
