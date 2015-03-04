//
//  Tokens.swift
//  docopt
//
//  Created by Pavel S. Mazurin on 3/1/15.
//  Copyright (c) 2015 kovpas. All rights reserved.
//

import Foundation

internal class Tokens: Equatable, Printable {
    private var tokensArray: [String]
    internal var error: DocoptError
    
    internal var description: String {
        get {
            return " ".join(tokensArray)
        }
    }

    
    internal convenience init(_ source: String, error: DocoptError = DocoptExit()) {
        self.init(source.split(), error: error)
    }
    
    internal init(_ source: [String], error: DocoptError = DocoptExit() ) {
        tokensArray = source
        self.error = error
    }
    
    static internal func fromPattern(source: String) -> Tokens {
        let res = source.stringByReplacingOccurrencesOfString("([\\[\\]\\(\\)\\|]|\\.\\.\\.)", withString: " $1 ", options: .RegularExpressionSearch)
        var result = res.split("\\s+|(\\S*<.*?>)").filter { !$0.isEmpty }
        return Tokens(result, error: DocoptLanguageError())
    }
    
    internal func current() -> String? {
        if tokensArray.isEmpty {
            return nil
        }
        
        return tokensArray[0]
    }
    
    internal func move() -> String? {
        if tokensArray.isEmpty {
            return nil
        }
        return tokensArray.removeAtIndex(0)
    }
}

func ==(lhs: Tokens, rhs: Tokens) -> Bool {
    return lhs.tokensArray == rhs.tokensArray
}
