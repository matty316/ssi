//
//  Env.swift
//
//
//  Created by matty on 10/16/23.
//

import Foundation

class Env {
    private var store: [String: Object]
    private var outer: Env?
    
    init() {
        self.store = [String: Object]()
        self.outer = nil
    }
    
    init(outer: Env) {
        self.store = [String: Object]()
        self.outer = outer
    }
    
    func getEnv(name: String) -> Object? {
        var obj = store[name]
        if let outer = outer, obj == nil {
            obj = outer.getEnv(name: name)
        }
        return obj
    }
    
    func setEnv(name: String, val: Object) -> Object {
        store[name] = val
        return val
    }
}
