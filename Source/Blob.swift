//
//  Blob.swift
//  JavaScriptCoreBrowserObjectModel
//
//  Created by Connor Grady on 1/17/18.
//  Copyright © 2018 Connor Grady. All rights reserved.
//

import Foundation
import JavaScriptCore

@objc protocol BlobJSProtocol: JSExport, EventTargetJSProtocol {
    var size: Int { get }
    var type: String { get }
    //
    init(_ blobParts: [JSValue], _ options: [String: String]?)
    func slice(_ start: Int?, _ end: Int?, _ contentType: String?) -> Blob
    // Events
    // - loadstart
    // - progress
    // - abort
    // - error
    // - load
    // - loadend
}

@objc public class Blob: /*NSObject*/EventTarget, BlobJSProtocol {
    
    public var size: Int = 0
    public var type: String = ""
    
    public required init(_ blobParts: [JSValue], _ options: [String : String]? = nil) {
        super.init()
    }
    
    public func slice(_ start: Int? = 0, _ end: Int?, _ contentType: String? = "") -> Self {
        <#code#>
    }
    
    
}
