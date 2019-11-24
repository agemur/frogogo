//
//  BaseRepository.swift
//  FrogogoTestApp
//
//  Created by User on 11/24/19.
//  Copyright © 2019 User. All rights reserved.
//

import Foundation

protocol Repository: class {
    associatedtype Model
    
    var items: [Model]? {get}
    
    init(items: [Model]?)
    
    func countItems() -> Int
    func getState() -> DataRepositoryState
    func getItem(by index: Int) -> Model?
    func addItem(item: Model, by index: Int?)
    func clear()
}

class BaseRepository<Model>: Repository {
    typealias Item = Model
    
    internal var items: [Model]?
    
    required init(items: [Model]? = nil) {
        self.items = items
    }
    
    func clear() {
        self.items = []
    }
    
    func getState() -> DataRepositoryState {
        if items == nil {
            return .notInitialize
        } else if items?.count == 0 {
            return .empty
        } else {
            return .filled
        }
    }
    
    func countItems() -> Int {
        return items?.count ?? 0
    }
    
    func getItem(by index: Int) -> Model? {
        guard items?.count ?? 0 > index else { return nil }
        return items?[index]
    }
    
    func addItem(item: Model, by index: Int? = nil) {
        if items == nil {
            items = []
        }
        guard let index = index else {
            items?.append(item)
            return
        }
        items?.remove(at: index)
        items?.insert(item, at: index)
    }
}
