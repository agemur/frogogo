//
//  Encodable+ToDictionary.swift
//  FrogogoTestApp
//
//  Created by User on 11/22/19.
//  Copyright © 2019 User. All rights reserved.
//

import Foundation

extension Encodable {
    private func asDictionary<T>() -> [String: T]? {
        do {
            let data = try JSONEncoder().encode(self)
            guard let dictionary = try JSONSerialization.jsonObject(with: data, options: [])
                as? [String: T] else {
                return nil
            }
            let encoder = JSONEncoder()
            if let json = try? encoder.encode(self) {
                print(String(data: json, encoding: .utf8)!)
            }

            return dictionary
        } catch {
            print(error.localizedDescription)
        }
        return nil
    }
    
    func asAnyDictionary() -> [String: Any]? {
        return asDictionary()
    }

    func asStringDictionary() -> [String: String]? {
        return asDictionary()
    }
}
