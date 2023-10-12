//
//  AST.swift
//
//
//  Created by matty on 10/11/23.
//

import Foundation

protocol Node {
    var token: Token { get set }
    func tokenLiteral() -> String
    func string() -> String
}

extension Node {
    func tokenLiteral() -> String { return token.literal }
    func string() -> String { return token.literal }
}

protocol Statement: Node {
    func statementNode()
}

extension Statement {
    func statementNode() {}
}

protocol Expression: Node {
    func expressionNode()
}

extension Expression {
    func expressionNode() {}
}

struct Program {
    var statements: [Statement]
    
    init() {
        self.statements = []
    }
    
    init(statements: [Statement]) {
        self.statements = statements
    }
    
    func tokenLiteral() -> String {
        return statements.first?.tokenLiteral() ?? ""
    }
    
    func string() -> String {
        return statements.map { $0.string() }.joined()
    }
}

struct LetStatement: Statement {
    var token: Token
    var name: Identifier
    var value: Expression?
    
    func string() -> String {
        return "\(tokenLiteral()) \(name.string()) = \(value?.string() ?? "");"
    }
}

struct Identifier: Expression {
    var token: Token
    var value: String
    
    func string() -> String {
        return value
    }
}

struct ReturnStatement: Statement {
    var token: Token
    var value: Expression?
    
    func string() -> String {
        if let value = value {
            return "\(tokenLiteral()) \(value);"
        }
        return "\(tokenLiteral());"
    }
}

struct ExpressionStatement: Statement {
    var token: Token
    var expression: Expression?
    
    func string() -> String {
        return expression?.string() ?? ""
    }
}

struct IntegerLiteral: Expression {
    var token: Token
    var value: Int
}

struct PrefixExpression: Expression {
    var token: Token
    var operatorString: String
    var right: Expression
    
    func string() -> String {
        return "(\(operatorString)\(right.string()))"
    }
}

struct InfixExpresion: Expression {
    var token: Token
    var left: Expression
    var operatorString: String
    var right: Expression
    
    func string() -> String {
        return "(\(left.string()) \(operatorString) \(right.string()))"
    }
}

struct BooleanExpression: Expression {
    var token: Token
    var value: Bool
}

struct IfExpression: Expression {
    var token: Token
    var condition: Expression
    var consequence: BlockStatement
    var alternative: BlockStatement?
    
    func string() -> String {
        if let alternative = alternative {
            return "if \(condition.string()) \(consequence.string()) else \(alternative.string())"
        }
        return "if \(condition.string()) \(consequence.string())"
    }
}

struct BlockStatement: Statement {
    var token: Token
    var statements: [Statement]
    
    func string() -> String {
        return statements.map { $0.string() }.joined()
    }
}

struct FunctionLiteral: Expression {
    var token: Token
    var params: [Identifier]
    var body: BlockStatement
    
    func string() -> String {
        let paramsString = params.map { $0.string() }.joined(separator: ", ")
        return "\(tokenLiteral())(\(paramsString))\(body.string())"
    }
}

struct CallExpression: Expression {
    var token: Token
    var fnExpression: Expression
    var args: [Expression]
    
    func string() -> String {
        let argsString = args.map { $0.string() }.joined(separator: ", ")
        return "\(fnExpression.string())(\(argsString))"
    }
}
