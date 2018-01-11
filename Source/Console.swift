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

@objc open class Console: NSObject, ConsoleProtocol {
    
    static var `default` = {
        return Console()
    }()
    
    private var stdout: TextOutputStream? //= ""
    private var stderr: TextOutputStream? //= ""
    
    public init(stdout: TextOutputStream? = nil, stderr: TextOutputStream? = nil) {
        super.init()
        self.stdout = stdout
        self.stderr = stderr ?? stdout
    }
    
    public func debug(_ message: String) -> Void {
        print(String(message))
    }
    
    public func error(_ message: String) -> Void {
        print(String(message))
    }
    
    public func info(_ message: String) -> Void {
        print(String(message))
    }
    
    public func log(_ message: String) -> Void {
        print(String(message))
    }
    
    public func warn(_ message: String) -> Void {
        print(String(message))
    }
    
}

// MARK: Static Methods

extension Console {
    public class func debug(_ message: String) -> Void {
        self.default.debug(message)
    }
    public class func error(_ message: String) -> Void {
        self.default.error(message)
    }
    public class func info(_ message: String) -> Void {
        self.default.info(message)
    }
    public class func log(_ message: String) -> Void {
        self.default.log(message)
    }
    public class func warn(_ message: String) -> Void {
        self.default.warn(message)
    }
}
