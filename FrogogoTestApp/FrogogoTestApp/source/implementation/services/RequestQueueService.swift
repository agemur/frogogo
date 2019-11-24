//
//  RequestQueueService.swift
//  FrogogoTestApp
//
//  Created by User on 11/24/19.
//  Copyright © 2019 User. All rights reserved.
//

import Foundation

class RequestQueueService<T: Hashable> {
    
    private var requestDic = [T: URLSessionTask]()
 
    func cancelRequest(by key: T) {
        guard requestDic.keys.contains(where: { $0 == key }) else {
            return
        }
        requestDic[key]?.cancel()
        requestDic.removeValue(forKey: key)
    }
    
    func addRequest (_ request: URLSessionTask, for key: T) {
        cancelRequest(by: key)
        requestDic[key] = request
    }
}
