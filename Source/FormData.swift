//
//  FormData.swift
//  JavaScriptCoreBrowserObjectModel
//
//  Created by Connor Grady on 1/17/18.
//  Copyright © 2018 Connor Grady. All rights reserved.
//

import Foundation
import JavaScriptCore

@objc protocol FormDataJSProtocol: JSExport, EventTargetJSProtocol {
    init()
    func append(_ name: String, _ value: JSValue, _ filename: String?) -> Void
    func delete(_ name: String) -> Void
    //func entries() -> [String: JSValue]
    //func entries() -> [[String, JSValue]]
    //func entries() -> [(String, JSValue)]
    func get(_ name: String) -> JSValue?
    //func get(_ name: String) -> FormDataEntryValue?
    func getAll(_ name: String) -> [JSValue]
    //func getAll(_ name: String) -> [FormDataEntryValue]
    func has(_ name: String) -> Bool
    func keys() -> [String]
    func set(_ name: String, _ value: JSValue, _ filename: String?) -> Void
    func values() -> [JSValue]
    // Events
    // - loadstart
    // - progress
    // - abort
    // - error
    // - load
    // - timeout
    // - loadend
    // - readystatechange
}

@objc public class FormData: /*NSObject*/EventTarget, FormDataJSProtocol {
    
    public override required init() {
        super.init()
    }
    
    func append(_ name: String, _ value: JSValue, _ filename: String? = nil) -> Void {
        print("FormData append( name: \(name), value: \(value), filename: \(String(describing: filename)) )")
        // NOTE: `value` can be a `String` or `Blob` (including subclasses such as `File`)
    }
    
    func delete(_ name: String) -> Void {
        print("FormData delete( name: \(name) )")
    }
    
    //func entries() -> [String: JSValue] {
    //func entries() -> [[String, JSValue]] {
    //func entries() -> [(String, JSValue)] {
    //    print("FormData entries()")
    //}
    
    func get(_ name: String) -> JSValue? {
    //func get(_ name: String) -> FormDataEntryValue? {
        print("FormData get( name: \(name) )")
        return nil
    }
    
    func getAll(_ name: String) -> [JSValue] {
    //func getAll(_ name: String) -> [FormDataEntryValue] {
        print("FormData getAll( name: \(name) )")
        return []
    }
    
    func has(_ name: String) -> Bool {
        print("FormData has( name: \(name) )")
        return false
    }
    
    func keys() -> [String] {
        print("FormData keys()")
        return []
    }
    
    func set(_ name: String, _ value: JSValue, _ filename: String? = nil) -> Void {
        print("FormData set( name: \(name), value: \(value), filename: \(String(describing: filename)) )")
    }
    
    func values() -> [JSValue] {
        print("FormData values()")
        return []
    }
    
}
