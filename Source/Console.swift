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
    //init()
    //init(stdout: TextOutputStream?, stderr: TextOutputStream?)
    func debug(_ message: String) -> Void
    func error(_ message: String) -> Void
    func info(_ message: String) -> Void
    func log(_ message: String) -> Void
    func warn(_ message: String) -> Void
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
        //print(String(message) + "\n")
        //guard var stdout = stdout else { return }
        //print(String(message) + "\n", to: &stdout)
        stdout?.write(String(message) + "\n")
    }
    
    public func error(_ message: String) -> Void {
        stderr?.write(String(message) + "\n")
    }
    
    public func info(_ message: String) -> Void {
        stdout?.write(String(message) + "\n")
    }
    
    public func log(_ message: String) -> Void {
        stdout?.write(String(message) + "\n")
    }
    
    public func warn(_ message: String) -> Void {
        stdout?.write(String(message) + "\n")
    }
    
}
