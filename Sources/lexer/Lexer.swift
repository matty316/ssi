//
//  Lexer.swift
//
//
//  Created by matty on 10/10/23.
//

import Foundation

class Lexer {
    let input: String
    var position: String.Index
    var readPosition: String.Index
    var char: Character
    
    init(input: String) {
        self.input = input
        self.position = input.startIndex
        self.readPosition = input.index(after: input.startIndex)
        if let firstChar = input.first {
            self.char = firstChar
        } else {
            self.char = "\0"
        }
    }
    
    func readChar() {
        if readPosition >= input.endIndex {
            char = "\0"
        } else {
            char = input[readPosition]
            position = readPosition
            readPosition = input.index(after: readPosition)
        }
    }
    
    func nextToken() -> Token {
        let token: Token
        
        skipWhitespace()
        
        switch char {
        case "=":
            if peek() == "=" {
                let c = char
                readChar()
                let literal = String(c) + String(char)
                token = Token(tokenType: .eq, literal: literal)
            } else {
                token = newToken(tokenType: .assign, char: char)
            }
        case "+":
            token = newToken(tokenType: .plus, char: char)
        case "-":
            token = newToken(tokenType: .minus, char: char)
        case "!":
            if peek() == "=" {
                let c = char
                readChar()
                let literal = String(c) + String(char)
                token = Token(tokenType: .notEq, literal: literal)
            } else {
                token = newToken(tokenType: .bang, char: char)
            }
        case "/":
            token = newToken(tokenType: .slash, char: char)
        case "*":
            token = newToken(tokenType: .asterisk, char: char)
        case "<":
            token = newToken(tokenType: .lt, char: char)
        case ">":
            token = newToken(tokenType: .gt, char: char)
        case ";":
            token = newToken(tokenType: .semicolon, char: char)
        case ",":
            token = newToken(tokenType: .comma, char: char)
        case "(":
            token = newToken(tokenType: .lParen, char: char)
        case ")":
            token = newToken(tokenType: .rParen, char: char)
        case "{":
            token = newToken(tokenType: .lBrace, char: char)
        case "}":
            token = newToken(tokenType: .rBrace, char: char)
        case "\0":
            token = Token(tokenType: .eof, literal: "eof")
        default:
            if isLetter(char: char) {
                let id = readIdentifier()
                token = Token(tokenType: Token.lookupIdentifier(id: id), literal: id)
                return token
            } else if isDigit(char: char) {
                token = Token(tokenType: .int, literal: readNumber())
                return token
            } else {
                token = newToken(tokenType: .illegal, char: char)
            }
        }
        
        readChar()
        return token
    }
    
    func newToken(tokenType: Token.TokenType, char: Character) -> Token {
        return Token(tokenType: tokenType, literal: String(char))
    }
    
    func peek() -> Character {
        if readPosition >= input.endIndex {
            return "\0"
        } else {
            return input[readPosition]
        }
    }
    
    func skipWhitespace() {
        while char == " " || char == "\t" || char == "\n" || char == "\r" {
            readChar()
        }
    }
    
    func readIdentifier() -> String {
        let currentPosition = position
        while isLetter(char: char) {
            readChar()
        }
        return String(input[currentPosition..<position])
    }
    
    func isLetter(char: Character) -> Bool {
        return char.isLetter || char == "_"
    }
    
    func readNumber() -> String {
        let currentPosition = position
        while isDigit(char: char) {
            readChar()
        }
        return String(input[currentPosition..<position])
    }
    
    func isDigit(char: Character) -> Bool {
        return "0" <= char && "9" >= char
    }
}
