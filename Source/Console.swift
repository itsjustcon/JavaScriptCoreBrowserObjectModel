//
//  Console.swift
//  JavaScriptCoreBrowserObjectModel
//
//  Created by Connor Grady on 10/7/17.
//  Copyright © 2017 Connor Grady. All rights reserved.
//

import Foundation
import JavaScriptCore

@objc protocol ConsoleProtocol : JSExport {
    static func debug(_ message: String) -> Void
    static func error(_ message: String) -> Void
    static func info(_ message: String) -> Void
    static func log(_ message: String) -> Void
    static func warn(_ message: String) -> Void
}

@objc class Console: NSObject, ConsoleProtocol {
    
    public class func debug(_ message: String) -> Void {
        print(String(message))
    }
    
    public class func error(_ message: String) -> Void {
        print(String(message))
    }
    
    public class func info(_ message: String) -> Void {
        print(String(message))
    }
    
    public class func log(_ message: String) -> Void {
        print(String(message))
    }
    
    public class func warn(_ message: String) -> Void {
        print(String(message))
    }
    
}
