//
//  Object.swift
//
//
//  Created by matty on 10/16/23.
//

import Foundation

typealias ObjectType = String

protocol Object {
    func objectType() -> ObjectType
    func inspect() -> String
}

extension Object {
    var intObj: String { "INTEGER" }
    var boolObj: String { "BOOLEAN" }
    var nullObj: String { "NULL" }
    var returnValObj: String { "RETURN_VALUE" }
    var errorObj: String { "ERROR" }
    var funcObj: String { "FUNCTION" }
}

struct Integer: Object {
    let value: Int
    
    func objectType() -> ObjectType {
        return intObj
    }
    
    func inspect() -> String {
        return "\(value)"
    }
}

struct Boolean: Object, Equatable {
    let value: Bool
    
    func objectType() -> ObjectType {
        return boolObj
    }
    
    func inspect() -> String {
        return "\(value)"
    }
}

struct Null: Object {
    func objectType() -> ObjectType {
        return nullObj
    }
    
    func inspect() -> String {
        return "null"
    }
}

struct ReturnValue: Object {
    let value: Object
    
    func objectType() -> ObjectType {
        return returnValObj
    }
    
    func inspect() -> String {
        return value.inspect()
    }
}

struct Error: Object {
    let message: String
    
    func objectType() -> ObjectType {
        return errorObj
    }
    
    func inspect() -> String {
        return "ERROR: \(message)"
    }
}

struct Function: Object {
    let params: [Identifier]
    let body: BlockStatement
    let env: Env
    
    func objectType() -> ObjectType {
        return funcObj
    }
    
    func inspect() -> String {
        let paramsString = params.map { $0.string() }.joined(separator: ", ")
        return "fn(\(paramsString)) {\n\(body.string())\n}"
    }
}
