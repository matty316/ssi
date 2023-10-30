//
//  File.swift
//  
//
//  Created by matty on 10/16/23.
//

import Foundation

struct Evaluator {
    static let trueObj = Boolean(value: true)
    static let falseObj = Boolean(value: false)
    static let nullObj = Null()
    
    func isError(obj: Object?) -> Bool {
        if let obj = obj {
            return obj.objectType() == obj.errorObj
        }
        return false
    }
    
    func newError(message: String) -> Error {
        return Error(message: message)
    }
    
    func eval(node: Node?, env: Env) -> Object? {
        switch node {
        case let program as Program:
            return evalProgram(program: program, env: env)
        case let expr as ExpressionStatement:
            return eval(node: expr.expression, env: env)
        case let intLit as IntegerLiteral:
            return Integer(value: intLit.value)
        case let prefixExpr as PrefixExpression:
            let right = eval(node: prefixExpr.right, env: env)
            if isError(obj: right) {
                return right
            }
            return evalPrefix(op: prefixExpr.operatorString, right: right)
        case let infixExpr as InfixExpresion:
            let left = eval(node: infixExpr.left, env: env)
            if isError(obj: left) {
                return left
            }
            let right = eval(node: infixExpr.right, env: env)
            if isError(obj: right) {
                return right
            }
            return evalInfix(op: infixExpr.operatorString, left: left, right: right)
        case let boolLit as BooleanExpression:
            return nativeBoolToObj(input: boolLit.value)
        default:
            return nil
        }
    }
    
    func evalProgram(program: Program, env: Env) -> Object? {
        var result: Object?
        
        for stmt in program.statements {
            result = eval(node: stmt, env: env)
            
            if let returnVal = result as? ReturnValue {
                return returnVal.value
            } else if let errorObj = result as? Error {
                return errorObj
            }
        }
        
        return result
    }
    
    func evalPrefix(op: String, right: Object?) -> Object {
        switch op {
        case "!":
            return evalBang(right: right)
        case "-":
            return evalMinusPrefix(right: right)
        default:
            return newError(message: "unknown operator: \(op)\(right?.objectType() ?? "")")
        }
    }
    
    func evalBang(right: Object?) -> Object {
        if let right = right as? Boolean {
            if right.value {
                return Evaluator.falseObj
            } else {
                return Evaluator.trueObj
            }
        } else if right is Null {
            return Evaluator.trueObj
        } else {
            return Evaluator.falseObj
        }
    }
    
    func evalMinusPrefix(right: Object?) -> Object {
        guard let right = right as? Integer else {
            return newError(message: "unknown operator: -\(right?.objectType() ?? "")")
        }
        
        let val = right.value
        return Integer(value: -val)
    }
    
    func evalInfix(op: String, left: Object?, right: Object?) -> Object {
        if let left = left as? Integer, let right = right as? Integer {
            return evalIntInfix(op: op, left: left, right: right)
        } else {
            return newError(message: "unknown operator: \(left?.objectType() ?? "") \(op) \(right?.objectType() ?? "")")
        }
    }
    
    func evalIntInfix(op: String, left: Object?, right: Object?) -> Object {
        if let left = left as? Integer, let right = right as? Integer {
            if op == "+" {
                return Integer(value: left.value + right.value)
            } else if op == "-" {
                return Integer(value: left.value - right.value)
            } else if op == "*" {
                return Integer(value: left.value * right.value)
            } else if op == "/" {
                return Integer(value: left.value / right.value)
            } else {
                return newError(message: "unknown operator: \(left.objectType()) \(op) \(right.objectType())")
            }
        } else {
            return newError(message: "unknown operator: \(left?.objectType() ?? "") \(op) \(right?.objectType() ?? "")")
        }
    }
    
    func nativeBoolToObj(input: Bool) -> Boolean {
        if input {
            return Evaluator.trueObj
        }
        return Evaluator.falseObj
    }
}
