//
//  eval-tests.swift
//  
//
//  Created by matty on 10/16/23.
//

import XCTest
@testable import ssi

final class eval_tests: XCTestCase {
    
    func checkEval(input: String) -> Object? {
        let l = Lexer(input: input)
        let p = Parser(lexer: l)
        let program = p.parseProgram()
        let env = Env()
        return Evaluator().eval(node: program, env: env)
    }
    
    func checkIntObj(obj: Object, exp: Int) {
        guard let intObj = obj as? Integer else {
            XCTFail()
            return
        }
        
        XCTAssertEqual(intObj.value, exp)
    }
    
    func testEvalIntExpr() {
        let exp = [
            ("5", 5),
            ("10", 10),
            ("-5", -5),
            ("-10", -10),
            ("5 + 5 + 5 + 5 - 10", 10),
            ("2 * 2 * 2*2*2",  32),
            ("-50 +100 -50", 0),
            ("5* 2 + 10", 20),
            ("5 + 2 * 10", 25),
            ("20 + 2 * -10", 0),
            ("50 / 2 * 2 + 10", 60),
            ("2* (5 + 10)", 30),
            ("3 * 3 * 3 + 10", 37),
            ("3 * (3 * 3) + 10", 37),
            ("(5 + 10 * 2 + 15 / 3) * 2 + -10", 50),
        ]
        for e in exp {
            let eval = checkEval(input: e.0)
            checkIntObj(obj: eval!, exp: e.1)
        }
    }
}
