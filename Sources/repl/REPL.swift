//
//  File.swift
//  
//
//  Created by matty on 10/12/23.
//

import Foundation

struct REPL {
    let prompt = ">> "
    func start() {
        while true {
            print(prompt, terminator: "")

            guard let line = readLine() else {
                return
            }
            
            let l = Lexer(input: line)
            let p = Parser(lexer: l)
            
            let program = p.parseProgram()
            
            if !p.errors.isEmpty {
                p.errors.forEach {
                    print($0)
                }
            }
            
            program.statements.forEach {
                print($0.string())
            }
        }
    }
}
