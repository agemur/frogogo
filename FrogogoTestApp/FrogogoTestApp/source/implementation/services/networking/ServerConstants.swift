//
//  ServerConstants.swift
//  FrogogoTestApp
//
//  Created by User on 11/22/19.
//  Copyright © 2019 User. All rights reserved.
//

import Foundation


protocol ServerProtocol {
    static var domenURL: String { get }
}

//This structure allows you to create various configurations for server settings.
struct ServerConstants {
    static var currentServer: ServerProtocol.Type {
        #if DEBUG
            return DemoServer.self
        #else
            return ProductionServer.self
        #endif
    }
    
    static func baseURL(path: String) -> URL? {
        return URL(string: "\(currentServer.domenURL)\(path)")
    }
        
    
    private struct ProductionServer: ServerProtocol {
        static let domenURL = "https://frogogo-test.herokuapp.com"
    }
    
    private struct DemoServer: ServerProtocol {
        static let domenURL = "https://frogogo-test.herokuapp.com"
    }
}

