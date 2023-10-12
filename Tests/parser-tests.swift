//
//  parser-tests.swift
//  
//
//  Created by matty on 10/11/23.
//

import XCTest
@testable import ssi

final class parser_tests: XCTestCase {
    
    func checkParserErrors(p: Parser) {
        if p.errors.isEmpty {
            return
        }
        
        XCTFail(p.errors.joined(separator: ", "))
    }
    
    func checkLetStatment(stmt: Statement, name: String) {
        XCTAssertEqual(stmt.tokenLiteral(), "let")
        guard let letStmt = stmt as? LetStatement else {
            XCTFail()
            return
        }
        XCTAssertEqual(letStmt.name.string(), name)
        XCTAssertEqual(letStmt.name.tokenLiteral(), name)
    }
    
    func checkLiteralExpression(exp: Expression?, v: Any) {
        switch v.self {
        case is Int:
            break
        default:
            break
        }
    }
    
    func testLetStatement() {
        let expected: [(String, String, Any)] = [
            ("let x = 5;", "x", 5),
            ("let y = true;", "y", true),
            ("let foobar = y;", "foobar", "y"),
        ]
        
        for e in expected {
            let l = Lexer(input: e.0)
            let p = Parser(lexer: l)
            let program = p.parseProgram()
            
            checkParserErrors(p: p)
            
            XCTAssertEqual(program.statements.count, 1)
            if let statement = program.statements.first {
                checkLetStatment(stmt: statement, name: e.1)
                if let letStatement = statement as? LetStatement {
                    checkLiteralExpression(exp: letStatement.value, v: e.2)
                }
            }
        }
    }
}
