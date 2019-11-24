//
//  APIClient.swift
//  FrogogoTestApp
//
//  Created by User on 11/22/19.
//  Copyright © 2019 User. All rights reserved.
//

import Foundation


class APIClient {
    static func getUsers(completion: @escaping ([UserModel]?, Error?) -> Void ) {
        APIClient.request(route: APIRouter.getUsers, completion: completion)
    }
    
    static func createUser(
        user: CreateUserWrapper,
        completion: @escaping (UserModel?, Error?) -> Void
    ) {
        APIClient.request(route: APIRouter.createUser(user: user), completion: completion)
    }
    
    static func updateUser(
        user: CreateUserWrapper,
        completion: @escaping (UserModel?, Error?) -> Void
    ) {
        APIClient.request(route: APIRouter.updateUser(user: user), completion: completion)
    }
}


extension APIClient {
    private static func request<T: Decodable>(route: URLRequestConvertible, completion: @escaping (T?, Error?) -> Void) {
        guard let url = ServerConstants.baseURL(path: route.path) else {
            fatalError("ServerConstants not configure")
        }

        guard let request = route.request(url: url) else {
            print("Request error")
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                if let error = error {
                    completion(nil, error)
                    print("Client error! \(error.localizedDescription)")
                }
                completion(nil, NSError.internalServerError)
                return
            }

            guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                completion(nil, NSError.undefinedServerError)
                print("Server error!")
                return
            }

            do {
                let result = try JSONDecoder().decode(T.self, from: data)
                completion(result, nil)
            } catch {
                completion(nil, NSError.serverDataError)
                print("JSON error: \(error.localizedDescription)")
            }
        }

        task.resume()
    }
}
