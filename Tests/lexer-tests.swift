//
//  lexer-tests.swift
//  
//
//  Created by matty on 10/10/23.
//

import XCTest
@testable import ssi

final class lexer_tests: XCTestCase {
    func testLexer() {
        let input = """
        let five = 5;
        let ten = 10;
            
        let add = fn(x, y) {
          x + y;
        };
        
        let result = add(five, ten);
        !-/*5;
        5 < 10 > 5;

        if (5 < 10) {
            return true;
        } else {
            return false;
        }

        10 == 10;
        10 != 9;
        """
        
        let expectedTokens: [(Token.TokenType, String)] = [
            (.letToken, "let"),
            (.identifier, "five"),
            (.assign, "="),
            (.int, "5"),
            (.semicolon, ";"),
            (.letToken, "let"),
            (.identifier, "ten"),
            (.assign, "="),
            (.int, "10"),
            (.semicolon, ";"),
            (.letToken, "let"),
            (.identifier, "add"),
            (.assign, "="),
            (.fnToken, "fn"),
            (.lParen, "("),
            (.identifier, "x"),
            (.comma, ","),
            (.identifier, "y"),
            (.rParen, ")"),
            (.lBrace, "{"),
            (.identifier, "x"),
            (.plus, "+"),
            (.identifier, "y"),
            (.semicolon, ";"),
            (.rBrace, "}"),
            (.semicolon, ";"),
            (.letToken, "let"),
            (.identifier, "result"),
            (.assign, "="),
            (.identifier, "add"),
            (.lParen, "("),
            (.identifier, "five"),
            (.comma, ","),
            (.identifier, "ten"),
            (.rParen, ")"),
            (.semicolon, ";"),
            (.bang, "!"),
            (.minus, "-"),
            (.slash, "/"),
            (.asterisk, "*"),
            (.int, "5"),
            (.semicolon, ";"),
            (.int, "5"),
            (.lt, "<"),
            (.int, "10"),
            (.gt, ">"),
            (.int, "5"),
            (.semicolon, ";"),
            (.ifToken, "if"),
            (.lParen, "("),
            (.int, "5"),
            (.lt, "<"),
            (.int, "10"),
            (.rParen, ")"),
            (.lBrace, "{"),
            (.returnToken, "return"),
            (.trueToken, "true"),
            (.semicolon, ";"),
            (.rBrace, "}"),
            (.elseToken, "else"),
            (.lBrace, "{"),
            (.returnToken, "return"),
            (.falseToken, "false"),
            (.semicolon, ";"),
            (.rBrace, "}"),
            (.int, "10"),
            (.eq, "=="),
            (.int, "10"),
            (.semicolon, ";"),
            (.int, "10"),
            (.notEq, "!="),
            (.int, "9"),
            (.semicolon, ";"),
            (.eof, "eof")
        ]
        
        let lexer = Lexer(input: input)
        
        for et in expectedTokens {
            let token = lexer.nextToken()
            
            XCTAssertEqual(et.0, token.tokenType)
            XCTAssertEqual(et.1, token.literal)
        }
    }
}
