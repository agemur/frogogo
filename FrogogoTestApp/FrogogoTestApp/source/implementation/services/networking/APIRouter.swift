//
//  APIRouter.swift
//  FrogogoTestApp
//
//  Created by User on 11/22/19.
//  Copyright © 2019 User. All rights reserved.
//

import Foundation

enum HTTPMethod: String {
    case post = "POST"
    case get = "GET"
    case patch = "PATCH"
}

protocol URLRequestConvertible {
    var path: String { get }    
    func request(url: URL) -> URLRequest?
}

enum APIRouter: URLRequestConvertible {
        
    case getUsers
    case createUser(user: CreateUserWrapper)
    case updateUser(user: CreateUserWrapper)
    
    // MARK: - HTTPMethod
    var methot: HTTPMethod {
        switch self {
        case .getUsers:     return .get
        case .createUser:   return .post
        case .updateUser:   return .patch
        }
    }
    
    
    // MARK: - Path
    var path: String {
        switch self {
        case .getUsers:
            return "/users.json"
        case .createUser:
            return "/users.json"
        case .updateUser(let user):
            return "/users/\(user.user.id).json"
        }
    }
    
    
    // MARK: - Headers
    var headers: [String: String]? {
        return ["Content-Type" : "application/json"]
    }
    
    
    // MARK: - Parameters
    var parameters: [String: Any]? {
        switch self {
        case .createUser(let user),
             .updateUser(let user):
            
            return user.asAnyDictionary()
        case .getUsers: return nil
        }
    }
    
    func request(url: URL) -> URLRequest? {
        guard let params = parameters else {
            var request = URLRequest(url: url)
            request.httpMethod = self.methot.rawValue
            return request
        }
        
        switch methot {
        case .post, .patch:
            guard let httpBody = try? JSONSerialization.data(withJSONObject: params, options: []) else {
                return nil
            }
            var request = URLRequest(url: url)
            request.httpMethod = self.methot.rawValue
            request.httpBody = httpBody
            return addHeaders(request: request)
        case .get:
            guard let params = params as? [String: String] else {
                return nil
            }
            var components = URLComponents(string: url.absoluteString)!
            components.queryItems = params.map { (arg) -> URLQueryItem in
                let (key, value) = arg
                return URLQueryItem(name: key, value: value)
            }
            components.percentEncodedQuery = components.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
            let request = URLRequest(url: components.url!)
            
            return addHeaders(request: request)
        }
    }
    
    private func addHeaders(request: URLRequest) -> URLRequest {
        var request = request
        if let headers = headers {
            for (key, value) in headers {
                request.addValue(value, forHTTPHeaderField: key)
            }
        }
        return request
    }

}

