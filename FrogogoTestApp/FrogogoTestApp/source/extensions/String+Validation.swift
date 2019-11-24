//
//  String+Validation.swift
//  FrogogoTestApp
//
//  Created by User on 11/24/19.
//  Copyright © 2019 User. All rights reserved.
//

import Foundation

extension String {
    func hasChars() -> Bool {
        return count <= 0 ? false : isWhiteSpacesOrNewlines()
    }

    func isWhiteSpacesOrNewlines() -> Bool {
        let whiteSpaceNewLineCharSet = CharacterSet.whitespacesAndNewlines
        let nonWhiteSpaceNewlineStr = components(separatedBy: whiteSpaceNewLineCharSet).joined(separator: "")

        return nonWhiteSpaceNewlineStr.count > 0
    }
}
