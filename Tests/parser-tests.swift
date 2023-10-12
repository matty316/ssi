//
//  parser-tests.swift
//  
//
//  Created by matty on 10/11/23.
//

import XCTest
@testable import ssi

final class parser_tests: XCTestCase {
    
    func setup(input: String) -> [Statement] {
        let l = Lexer(input: input)
        let p = Parser(lexer: l)
        let program = p.parseProgram()
        
        checkParserErrors(p: p)
        XCTAssertEqual(program.statements.count, 1)
        
        return program.statements
    }
    
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
    
    func checkInfixExpressing(exp: Expression?, left: Any, op: String, right: Any) {
        guard let opExp = exp as? InfixExpresion else {
            XCTFail()
            return
        }
        
        checkLiteralExpression(exp: opExp.left, v: left)
        XCTAssertEqual(opExp.operatorString, op)
        checkLiteralExpression(exp: opExp.right, v: right)
    }
    
    func testLetStatement() {
        let expected: [(String, String, Any)] = [
            ("let x = 5;", "x", 5),
            ("let y = true;", "y", true),
            ("let foobar = y;", "foobar", "y"),
        ]
        
        for e in expected {
            if let statement = setup(input: e.0).first {
                checkLetStatment(stmt: statement, name: e.1)
                if let letStatement = statement as? LetStatement {
                    checkLiteralExpression(exp: letStatement.value, v: e.2)
                }
            }
        }
    }
    
    func testReturnStatement() {
        let expected: [(String, Any)] = [
            ("return 5;", 5),
            ("return true;", true),
            ("return foobar;", "foobar"),
        ]
        
        for e in expected {
            guard let returnStmt = setup(input: e.0).first as? ReturnStatement else {
                XCTFail()
                return
            }
            
            XCTAssertEqual(returnStmt.tokenLiteral(), "return")
            checkLiteralExpression(exp: returnStmt.value, v: e.1)
        }
    }
    
    func testIdentifierExpession() {
                
        guard let stmt = setup(input: "foobar;").first as? ExpressionStatement else {
            XCTFail()
            return
        }

        guard let ident = stmt.expression as? Identifier else {
            XCTFail()
            return
        }
        
        XCTAssertEqual(ident.value, "foobar")
        XCTAssertEqual(ident.tokenLiteral(), "foobar")
    }
    
    func testIntegerLiteral() {
        guard let stmt = setup(input: "5;").first as? ExpressionStatement else {
            XCTFail()
            return
        }
        
        guard let lit = stmt.expression as? IntegerLiteral else {
            XCTFail()
            return
        }
        
        XCTAssertEqual(lit.value, 5)
        XCTAssertEqual(lit.tokenLiteral(), "5")
    }
    
    func testParsingPrefixExpression() {
        let expected: [(String, String, Any)] = [
            ("!5;", "!", 5),
            ("-15;", "-", 15),
            ("!foobar;", "!", "foobar"),
            ("-foobar;", "-", "foobar"),
            ("!true;", "!", true),
            ("!false;", "!", false),
        ]
        
        for e in expected {
            guard let stmt = setup(input: e.0).first as? ExpressionStatement else {
                XCTFail()
                return
            }
            
            guard let exp = stmt.expression as? PrefixExpression else {
                XCTFail()
                return
            }
            
            XCTAssertEqual(exp.operatorString, e.1)
            checkLiteralExpression(exp: exp.right, v: e.2)
        }
    }
    
    func testParsingInfixExpression() {
        let expected: [(String, Any, String, Any)] = [
            ("5 + 5;", 5, "+", 5),
            ("5 - 5;", 5, "-", 5),
            ("5 * 5;", 5, "*", 5),
            ("5 / 5;", 5, "/", 5),
            ("5 > 5;", 5, ">", 5),
            ("5 < 5;", 5, "<", 5),
            ("5 == 5;", 5, "==", 5),
            ("5 != 5;", 5, "!=", 5),
            ("foobar + barfoo;", "foobar", "+", "barfoo"),
            ("foobar - barfoo;", "foobar", "-", "barfoo"),
            ("foobar * barfoo;", "foobar", "*", "barfoo"),
            ("foobar / barfoo;", "foobar", "/", "barfoo"),
            ("foobar > barfoo;", "foobar", ">", "barfoo"),
            ("foobar < barfoo;", "foobar", "<", "barfoo"),
            ("foobar == barfoo;", "foobar", "==", "barfoo"),
            ("foobar != barfoo;", "foobar", "!=", "barfoo"),
            ("true == true", true, "==", true),
            ("true != false", true, "!=", false),
            ("false == false", false, "==", false),
        ]
        
        for e in expected {
            guard let stmt = setup(input: e.0).first as? ExpressionStatement else {
                XCTFail()
                return
            }
            
            checkInfixExpressing(exp: stmt.expression, left: e.1, op: e.2, right: e.3)
        }
    }
}
