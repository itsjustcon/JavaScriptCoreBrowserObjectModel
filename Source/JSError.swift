//
//  JSError.swift
//  JavaScriptCoreBrowserObjectModel
//
//  Created by Connor Grady on 1/22/18.
//  Copyright © 2018 Connor Grady. All rights reserved.
//

import Foundation
import JavaScriptCore

// SPEC: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Error
@objc public protocol ErrorJSProtocol: JSExport {
    var name: String? { get set }
    var message: String? { get set }
    var stack: [JSValue] { get }
    var fileName: String? { get }
    var lineNumber: Int { get }
    var columnNumber: Int { get }
    //
    //init(_ message: String?, _ fileName: String?, lineNumber: Int?)
    init(_ message: String?, _ fileName: String?, lineNumber: JSValue?)
    func toSource() -> String
    func toString() -> String
}

@objc public class JSError: NSObject, ErrorJSProtocol {
    
    public var name: String?
    public var message: String?
    
    public var stack: [JSValue] = [JSValue]()
    
    public var fileName: String?
    public var lineNumber: Int = 0
    public var columnNumber: Int = 0
    
    public required init(_ message: String?, _ fileName: String?, lineNumber: JSValue?) {
        self.message = message
        self.fileName = fileName
        if let lineNumber = lineNumber, lineNumber.isNumber {
            self.lineNumber = Int(lineNumber.toUInt32())
        }
    }
    
    public func toSource() -> String {
        return ""
    }
    
    public func toString() -> String {
        return ""
    }
    
    
}



public extension JSValue {
    
    var isError: Bool {
        guard isObject else { return false }
        if isInstance(of: JSError.self) { return true }
        let JSNativeError = context.objectForKeyedSubscript("Error")!
        guard JSNativeError.isObject else { return false }
        //var jsException: JSValueRef? = nil
        //return JSValueIsInstanceOfConstructor(context.jsGlobalContextRef, jsValueRef, JSNativeError.jsValueRef, &jsException)
        return JSValueIsInstanceOfConstructor(context.jsGlobalContextRef, jsValueRef, JSNativeError.jsValueRef, nil)
    }
    
    func toError() -> JSError {
        return toObjectOf(JSError.self) as! JSError
    }
    
}
