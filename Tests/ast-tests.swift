//
//  ast-tests.swift
//  
//
//  Created by matty on 10/11/23.
//

import XCTest
@testable import ssi

final class ast_tests: XCTestCase {

    func testAST() {
        let program = Program(statements: [
            LetStatement(token: Token(tokenType: .letToken, literal: "let"),
                         name: Identifier(token: Token(tokenType: .identifier, 
                                                       literal: "myVar"),
                                          value: "myVar"),
                         value: Identifier(token: Token(tokenType: .identifier,
                                                        literal: "anotherVar"),
                                           value: "anotherVar"))
        ])
        
        XCTAssertEqual(program.string(), "let myVar = anotherVar;")
    }

}
