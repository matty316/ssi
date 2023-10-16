// The Swift Programming Language
// https://docs.swift.org/swift-book
// 
// Swift Argument Parser
// https://swiftpackageindex.com/apple/swift-argument-parser/documentation

import ArgumentParser

@main
struct ssi: ParsableCommand {
    mutating func run() throws {
        print("hello! this is the saiyan programming language!")
        print("feel free to type in commands")
        
        REPL().start()
    }
}
