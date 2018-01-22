//
//  JSDocument.swift
//  JS Notepad
//
//  Created by Connor Grady on 1/6/18.
//  Copyright © 2018 Connor Grady. All rights reserved.
//

import UIKit

class JSDocument: UIDocument {
    
    var scriptText: String? = "// hello world"
    
    override var fileType: String? {
        return "com.netscape.javascript-​source"
    }
    
    override func contents(forType typeName: String) throws -> Any {
        // Encode your document with an instance of NSData or NSFileWrapper
        if let content = scriptText {
            let length = content.lengthOfBytes(using: .utf8)
            return NSData(bytes: content, length: length)
        } else {
            return Data()
        }
    }
    
    override func load(fromContents contents: Any, ofType typeName: String?) throws {
        // Load your document from contents
        if let userContent = contents as? Data {
            scriptText = NSString(bytes: (contents as AnyObject).bytes, length: userContent.count, encoding: String.Encoding.utf8.rawValue) as String?
            //scriptText = String(bytesNoCopy: (contents as AnyObject).mutableBytes!, length: userContent.count, encoding: .utf8, freeWhenDone: false)
            //let scriptText = String(bytes: (contents as AnyObject).bytes, encoding: .utf8)
        }
    }
}

