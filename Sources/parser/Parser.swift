//
//  Parser.swift
//
//
//  Created by matty on 10/11/23.
//

import Foundation

enum Precedence: Int {
    case lowest, equals, lessGreater, sum, product, prefix, call
}

class Parser {
    let lexer: Lexer
    var currentToken: Token
    var peekToken: Token
    var errors = [String]()
    typealias PrefixParseFn = () -> Expression?
    typealias InfixParseFn = (Expression?) -> Expression?
    var prefixParseFns = [Token.TokenType: PrefixParseFn]()
    var infixParseFns = [Token.TokenType: InfixParseFn]()
    
    let precedences: [Token.TokenType: Precedence] = [
        .eq: .equals,
        .notEq: .equals,
        .lt: .lessGreater,
        .gt: .lessGreater,
        .plus: .sum,
        .minus: .sum,
        .asterisk: .product,
        .slash: .product,
        .lParen: .call,
    ]
    
    init(lexer: Lexer) {
        self.lexer = lexer
        self.currentToken = lexer.nextToken()
        self.peekToken = lexer.nextToken()
        
        self.prefixParseFns[.identifier] = parseIdentifier
        self.prefixParseFns[.int] = parseIntegerLiteral
        self.prefixParseFns[.trueToken] = parseBoolean
        self.prefixParseFns[.falseToken] = parseBoolean
    }
    
    func currentTokenIs(_ type: Token.TokenType) -> Bool {
        return type == currentToken.tokenType
    }
    
    func peekTokenIs(_ type: Token.TokenType) -> Bool {
        return type == peekToken.tokenType
    }
    
    func nextToken() {
        currentToken = peekToken
        peekToken = lexer.nextToken()
    }
    
    func expectPeek(_ type: Token.TokenType) -> Bool {
        if peekTokenIs(type) {
            nextToken()
            return true
        } else {
            peekError(type)
            return false
        }
    }
    
    func peekPrecedence() -> Int {
        if let p = precedences[peekToken.tokenType] {
            return p.rawValue
        }
        return Precedence.lowest.rawValue
    }
    
    func currentPrecedence() -> Int {
        if let p = precedences[currentToken.tokenType] {
            return p.rawValue
        }
        return Precedence.lowest.rawValue
    }
    
    func peekError(_ type: Token.TokenType) {
        let msg = "expected next token to be \(type), got \(peekToken.tokenType)"
        print(msg)
        errors.append(msg)
    }
    
    func noPrefixParseFnError(_ type: Token.TokenType) {
        let msg = "no prefix parse function for \(type)"
        print(msg)
        errors.append(msg)
    }
    
    func parseProgram() -> Program {
        var program = Program()
        
        while !currentTokenIs(.eof) {
            if let statement = parseStatement() {
                program.statements.append(statement)
            }
            nextToken()
        }
        
        return program
    }
    
    func parseStatement() -> Statement? {
        switch currentToken.tokenType {
        case .letToken:
            return parseLetStatement()
        case .returnToken:
            return parseReturnStatement()
        default:
            return nil
        }
    }
    
    func parseLetStatement() -> LetStatement? {
        let token = currentToken
        
        if !expectPeek(.identifier) {
            return nil
        }

        let name = Identifier(token: currentToken, value: currentToken.literal)
        
        if !expectPeek(.assign) {
            return nil
        }
        
        nextToken()
        
        let value = parseExpression(precedence: .lowest)
        
        if peekTokenIs(.semicolon) {
            nextToken()
        }
        
        return LetStatement(token: token, name: name, value: value)
    }
    
    func parseReturnStatement() -> ReturnStatement? {
        let token = currentToken
        
        nextToken()
        
        let value = parseExpression(precedence: .lowest)
        
        if peekTokenIs(.semicolon) {
            nextToken()
        }
        
        return ReturnStatement(token: token, value: value)
    }
    
    func parseExpression(precedence: Precedence) -> Expression? {
        guard let prefix = prefixParseFns[currentToken.tokenType] else {
            noPrefixParseFnError(currentToken.tokenType)
            return nil
        }
        
        var left = prefix()
        
        while !peekTokenIs(.semicolon) && precedence.rawValue < peekPrecedence() {
            guard let infix = infixParseFns[peekToken.tokenType] else {
                return left
            }
            nextToken()
            left = infix(left)
        }
        
        return left
    }
    
    func parseIdentifier() -> Expression? {
        return Identifier(token: currentToken, value: currentToken.literal)
    }
    
    func parseIntegerLiteral() -> Expression? {
        let token = currentToken
        
        guard let value = Int(currentToken.literal) else {
            let msg = "could not parse \(currentToken.literal) as int"
            print(msg)
            errors.append(msg)
            return nil
        }
        
        return IntegerLiteral(token: token, value: value)
    }
    
    func parseBoolean() -> Expression? {
        return BooleanExpression(token: currentToken, value: currentTokenIs(.trueToken))
    }
}
