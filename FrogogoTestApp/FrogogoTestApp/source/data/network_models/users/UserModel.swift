//
//  UserModel.swift
//  FrogogoTestApp
//
//  Created by User on 11/22/19.
//  Copyright © 2019 User. All rights reserved.
//

import Foundation

struct UserModel: Codable {
    let id: Int
    var firstName: String
    var lastName: String
    var email: String
    
    private let createdDateStr: String
    private let avatarStr: String
    
    var avatarURL: URL? {
        return URL(string: avatarStr)
    }
    
    var description: String {
        return "\(firstName) \(lastName) \n Email: \(email)"
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case email
        case createdDateStr = "created_at"
        case avatarStr = "avatar_url"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        firstName = try container.decode(String.self, forKey: .firstName)
        lastName = try container.decode(String.self, forKey: .lastName)
        email = try container.decode(String.self, forKey: .email)
        createdDateStr = try container.decode(String.self, forKey: .createdDateStr)
        let avatar = try container.decodeIfPresent(String.self, forKey: .avatarStr)
        avatarStr = avatar ?? ""
    }
}
