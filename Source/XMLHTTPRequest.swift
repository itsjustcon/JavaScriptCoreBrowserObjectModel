//
//  XMLHTTPRequest.swift
//  JavaScriptCoreBrowserObjectModel
//
//  Created by Connor Grady on 11/14/17.
//  Copyright © 2017 Connor Grady. All rights reserved.
//

import Foundation
import JavaScriptCore

@objc protocol XMLHTTPRequestJSProtocol: JSExport, XMLHttpRequestEventTarget {
    var readyState: XMLHTTPRequestReadyState { get }
    var response: Any? { get }
    var responseText: String? { get }
    var responseType: XMLHTTPRequestResponseType { get }
    //var responseType: String { get }
    var responseURL: String? { get }
    //var responseXML: Any? { get }
    var status: XMLHTTPRequestStatus { get }
    var statusText: String? { get }
    var timeout: Int { get set }
    //var upload: XMLHttpRequestUpload { get }
    var withCredentials: Bool { get }
    //
    init()
    func abort() -> Void
    func getAllResponseHeaders() -> String?
    func getResponseHeader(_ name: String!) -> String?
    func open(_ method: String!, _ url: String!, _ async: Bool, _ user: String?, _ password: String?) -> Void
    func overrideMimeType(_ mimetype: String!) -> Void
    func send(_ body: String?) -> Void
    func setRequestHeader(_ header: String!, _ value: String!) -> Void
    // Events
    var onreadystatechange: EventListener? { get set }
}

//extension XMLHTTPRequestJSProtocol {
//    var responseType: XMLHTTPRequestResponseType { get }
//}

@objc public class XMLHTTPRequest: NSObject, XMLHTTPRequestJSProtocol {
    
    public var readyState: XMLHTTPRequestReadyState = .UNSENT // read-only
    
    public var response: Any?
    public var responseText: String?
    public var responseType: XMLHTTPRequestResponseType = .none //.text // NOTE: `.none` >> `.text`
    public var responseURL: String?
    //public var responseXML: Any?
    
    public var status: XMLHTTPRequestStatus = 0 // read-only
    public var statusText: String? // read-only
    
    public var timeout: Int = 0
    
    //public var upload: XMLHttpRequestUpload // read-only
    
    public var withCredentials: Bool = false // read-only
    
    public override required init() {
        print("XMLHTTPRequest init()")
    }
    
    public func abort() -> Void {
        print("XMLHTTPRequest abort()")
        
        status = 0 //.complete
        readyState = .DONE
        
    }
    
    public func getAllResponseHeaders() -> String? {
        print("XMLHTTPRequest getAllResponseHeaders()")
        
        return nil
        
    }
    public func getResponseHeader(_ name: String!) -> String? {
        print("XMLHTTPRequest getResponseHeader( name: \(name) )")
        
        return nil
        
    }
    
    public func open(_ method: String!, _ url: String!) -> Void {
        return self.open(method, url, true, nil, nil)
    }
    public func open(_ method: String!, _ url: String!, _ async: Bool = true) -> Void {
        return self.open(method, url, async, nil, nil)
    }
    public func open(_ method: String!, _ url: String!, _ async: Bool = true, _ user: String?) -> Void {
        return self.open(method, url, async, user, nil)
    }
    public func open(_ method: String!, _ url: String!, _ async: Bool = true, _ user: String?, _ password: String?) -> Void {
        print("XMLHTTPRequest open( method: \(method), url: \(url), async: \(async), user: \(String(describing: user)), password: \(String(describing: password)) )")
    }
    
    public func overrideMimeType(_ mimetype: String!) -> Void {
        print("XMLHTTPRequest overrideMimeType( mimetype: \(mimetype) )")
    }
    
    public func send(_ body: String?) -> Void {
        print("XMLHTTPRequest send( \(String(describing: body)) )")
    }
    
    public func setRequestHeader(_ header: String!, _ value: String!) -> Void {
        print("XMLHTTPRequest setRequestHeader( header: \(header), value: \(value) )")
    }
    
    //
    // MARK: - EventTarget
    //
    
    public func addEventListener(type: Event!, listener: EventListener!, options: EventListenerOptions?, useCapture: Bool) -> Void {
        print("XMLHTTPRequest addEventListener( type: \(type), listener: \(listener), options: \(String(describing: options)), useCapture: \(String(describing: useCapture)) )")
    }
    
    public func removeEventListener(type: Event!, listener: EventListener!, options: EventListenerOptions?, useCapture: Bool) -> Void {
        print("XMLHTTPRequest removeEventListener( type: \(type), listener: \(listener), options: \(String(describing: options)), useCapture: \(String(describing: useCapture)) )")
    }
    
    public func dispatchEvent(event: Event!) -> Bool {
        print("XMLHTTPRequest dispatchEvent( \(event) )")
        
        return true
        
    }
    
    //
    // MARK: - XMLHttpRequestEventTarget
    //
    
    public var onabort: EventListener?
    public var onerror: EventListener?
    public var onload: EventListener?
    public var onloadstart: EventListener?
    public var onprogress: EventListener?
    public var ontimeout: EventListener?
    public var onloadend: EventListener?
    
    //
    // MARK: - Events
    //
    
    public var onreadystatechange: EventListener?
    
}

// SPEC: https://developer.mozilla.org/en-US/docs/Web/API/XMLHttpRequestEventTarget
@objc public protocol XMLHttpRequestEventTarget: JSExport, EventTarget {
    var onabort: EventListener? { get set }
    var onerror: EventListener? { get set }
    var onload: EventListener? { get set }
    var onloadstart: EventListener? { get set }
    var onprogress: EventListener? { get set }
    var ontimeout: EventListener? { get set }
    var onloadend: EventListener? { get set }
}

// SPEC: https://developer.mozilla.org/en-US/docs/Web/API/XMLHttpRequestUpload
@objc public protocol XMLHttpRequestUpload: JSExport {
    
}

public typealias XMLHTTPRequestStatus = Int
//public enum XMLHTTPRequestStatus: Int {
//    case complete = 0
//    // HTTP Status Codes
//    case ok = 200
//}

// SPEC: https://developer.mozilla.org/en-US/docs/Web/API/XMLHttpRequest/readyState
@objc public enum XMLHTTPRequestReadyState: Int {
    case UNSENT = 0
    case OPENED = 1
    case HEADERS_RECEIVED = 2
    case LOADING = 3
    case DONE = 4
}

@objc public enum XMLHTTPRequestResponseType: Int, RawRepresentable {
    
    case none// = ""
    case arraybuffer
    case blob
    case document
    case json
    case text
    
    public typealias RawValue = String
    public var rawValue: RawValue {
        switch self {
        case .none:
            return ""
        case .arraybuffer:
            return "arraybuffer"
        case .blob:
            return "blob"
        case .document:
            return "document"
        case .json:
            return "json"
        case .text:
            return "text"
        }
    }
    public init?(rawValue: RawValue) {
        switch rawValue {
        case "arraybuffer":
            self = .arraybuffer
        case "blob":
            self = .blob
        case "document":
            self = .document
        case "json":
            self = .json
        case "text":
            self = .text
        default:
            self = .none
        }
    }
    
}
