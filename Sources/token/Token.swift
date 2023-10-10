//
//  Token.swift
//
//
//  Created by matty on 10/10/23.
//

import Foundation

struct Token {
    enum TokenType: String {
        case illegal
        case eof
        
        case identifier
        case int
        
        case assign = "="
        case plus = "+"
        case minus = "-"
        case bang = "!"
        case asterisk = "*"
        case slash = "/"
        
        case lt = "<"
        case gt = ">"
        case ltEq = "<="
        case gtEq = ">="
        case eq = "=="
        case notEq = "!="
        
        case lParen = "("
        case rParen = ")"
        case lBrace = "{"
        case rBrace = "}"
        
        case comma = ","
        case semicolon = ";"
        
        case fnToken = "function"
        case letToken = "let"
        case ifToken = "if"
        case elseToken = "else"
        case returnToken = "return"
        case trueToken = "true"
        case falseToken = "false"
    }
    
    static let keywords: [String: TokenType] = [
        "fn": .fnToken,
        "let": .letToken,
        "if": .ifToken,
        "else": .elseToken,
        "return": .returnToken,
        "true": .trueToken,
        "false": .falseToken,
    ]
    
    static func lookupIdentifier(id: String) -> TokenType {
        guard let token = keywords[id] else { return .identifier }
        return token
    }
    
    let tokenType: TokenType
    let literal: String
}
