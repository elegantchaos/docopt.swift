//
//  DocoptError.swift
//  docopt
//
//  Created by Pavel S. Mazurin on 3/1/15.
//  Copyright (c) 2015 kovpas. All rights reserved.
//

import Foundation

enum DocoptStatus: Int32 {
    case unknownError = 0x1000
    case languageError = 0x1001
    case incorrectArguments = 0x1002
}

internal class DocoptError {
    var message: String
    var name: String
    var status: DocoptStatus
    
    static var test: Bool = false
    static var errorMessage: String?
    
    init (_ message: String, name: String, status: DocoptStatus = .unknownError) {
        self.message = message
        self.name = name
        self.status = status
    }
    
    func raise(_ message: String? = nil) {
        let msg = (message ?? self.message).strip()
        if (DocoptError.test) {
            DocoptError.errorMessage = msg
        } else {
            print(msg)
            exit(status.rawValue)
        }
    }
}

internal class DocoptLanguageError: DocoptError {
    init (_ message: String = "Error in construction of usage-message by developer.") {
        super.init(message, name: "DocoptLanguageError", status: .languageError)
    }
}

internal class DocoptExit: DocoptError {
    static var usage: String = ""
    init (_ message: String = "Exit in case user invoked program with incorrect arguments.") {
        super.init(message, name: "DocoptExit", status: .incorrectArguments)
    }

    override func raise(_ message: String? = nil) {
        super.raise("\(DocoptExit.usage)")
    }
}
