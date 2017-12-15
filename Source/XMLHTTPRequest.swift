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
    var withCredentials: Bool { get set }
    //
    init()
    func abort() -> Void
    func getAllResponseHeaders() -> String?
    func getResponseHeader(_ name: String!) -> String?
    func open(_ method: String!, _ url: String!, _ async: Bool, _ user: String?, _ password: String?) -> Void
    func overrideMimeType(_ mimetype: String!) -> Void
    //func send(_ body: String?) -> Void
    func send(_ body: JSValue?) -> Void
    func setRequestHeader(_ header: String!, _ value: String!) -> Void
    // Events
    var onreadystatechange: EventListener? { get set }
}
//extension XMLHTTPRequestJSProtocol {
//    var responseType: XMLHTTPRequestResponseType { get }
//}

@objc public class XMLHTTPRequest: /*NSObject*/EventTarget, XMLHTTPRequestJSProtocol {
    
    public var readyState: XMLHTTPRequestReadyState = .UNSENT { // read-only
        didSet {
            //onreadystatechange?()
            //onreadystatechange?.value.call(withArguments: [])
            dispatchEvent("readystatechange")
        }
    }
    
    public var response: Any?
    public var responseText: String?
    public var responseType: XMLHTTPRequestResponseType = .none //.text // NOTE: `.none` >> `.text`
    public var responseURL: String?
    //public var responseXML: Any?
    
    public var status: XMLHTTPRequestStatus = 0 // read-only
    public var statusText: String? // read-only
    
    public var timeout: Int = 0
    
    //public var upload: XMLHttpRequestUpload // read-only
    
    public var withCredentials: Bool = false
    //public var withCredentials: Bool { return (_user != nil && _password != nil) } // read-only
    
    // MARK: Internal Variables
    //private var _urlSession: URLSession = URLSession.shared
    private lazy var _urlSession: URLSession = {
        return URLSession(configuration: /*.default*/.ephemeral, delegate: self, delegateQueue: nil)
        //return URLSession(configuration: .background(withIdentifier: "JavaScriptCoreBrowserObjectModel.XMLHTTPRequest"), delegate: self, delegateQueue: nil)
    }()
    private var _requestHeaders = [String: String]()
    private var _responseHeaders = [String: String]()
    private var _async: Bool = true
    private var _user: String?
    private var _password: String?
    
    private var _request: URLRequest?
    private var _dataTask: URLSessionDataTask?
    
    public override required init() {
        super.init()
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

    public func open(_ method: String!, _ url: String!, _ async: Bool = true, _ user: String? = nil, _ password: String? = nil) -> Void {
        print("XMLHTTPRequest open( method: \(method), url: \(url), async: \(async), user: \(String(describing: user)), password: \(String(describing: password)) )")
        
        _request = URLRequest(url: URL(string: url)!)
        //_request = URLRequest(url: URL(string: url)!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: TimeInterval(timeout))
        _request!.httpMethod = method
        _async = async
        _user = user
        _password = password
        
        readyState = .OPENED
        
    }
    
    public func overrideMimeType(_ mimetype: String!) -> Void {
        print("XMLHTTPRequest overrideMimeType( mimetype: \(mimetype) )")
    }
    
    //public func send(_ body: String?) -> Void {
    public func send(_ body: JSValue?) -> Void {
        print("XMLHTTPRequest send( \(String(describing: body)) )")
        
        for (header, value) in _requestHeaders {
            _request!.setValue(value, forHTTPHeaderField: header)
        }
        //_request!.timeoutInterval = TimeInterval(timeout)
        if body != nil && body!.isString {
            _request!.httpBody = body!.toString().data(using: .utf8)
        }
        
        let dataTask = _urlSession.dataTask(with: _request!) /*{ (data, response, error) in
            print("_dataTask callback!!!")
            self.readyState = .DONE
        }*/
        dataTask.resume()
        _dataTask = dataTask
        
        readyState = .OPENED
        //readyState = .HEADERS_RECEIVED
        
    }
    
    public func setRequestHeader(_ header: String!, _ value: String!) -> Void {
        print("XMLHTTPRequest setRequestHeader( header: \(header), value: \(value) )")
        //_request.setValue(value, forHTTPHeaderField: header)
        _requestHeaders[header] = value
    }
    
    //
    // MARK: - XMLHttpRequestEventTarget -
    //
    
    public var onabort: EventListener?
    public var onerror: EventListener?
    public var onload: EventListener?
    public var onloadstart: EventListener?
    public var onprogress: EventListener?
    public var ontimeout: EventListener?
    public var onloadend: EventListener?
    
    //
    // MARK: - Events -
    //
    
    public var onreadystatechange: EventListener?
    // TODO: investigate the need for this:
    //public var onreadystatechange: EventListener? {
    //    willSet {
    //        if self.onreadystatechange != nil, let context = JSContext.current() {
    //            context.virtualMachine.removeManagedReference(self.onreadystatechange!, withOwner: self)
    //        }
    //    }
    //    didSet {
    //        if self.onreadystatechange != nil, let context = JSContext.current() {
    //            context.virtualMachine.addManagedReference(self.onreadystatechange!, withOwner: self)
    //        }
    //    }
    //}
    
}

// SPEC: https://developer.mozilla.org/en-US/docs/Web/API/XMLHttpRequestEventTarget
@objc public protocol XMLHttpRequestEventTarget: JSExport, EventTargetJSProtocol {
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







// MARK: URLSessionDelegate

extension XMLHTTPRequest: URLSessionDelegate {
    
    public func urlSession(_ session: URLSession, didBecomeInvalidWithError error: Error?) {
        print("XMLHTTPRequest urlSession( session: \(session), didBecomeInvalidWithError: \(String(describing: error)) )")
    }
    
    public func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Swift.Void) {
        print("XMLHTTPRequest urlSession( session: \(session), didReceive: \(challenge), completionHandler: \(completionHandler) )")
    }
    
    public func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
        print("XMLHTTPRequest urlSessionDidFinishEvents( forBackgroundURLSession: \(session) )")
    }
    
}

// MARK: URLSessionTaskDelegate

extension XMLHTTPRequest: URLSessionTaskDelegate {
    
    @available(iOS 11.0, *)
    public func urlSession(_ session: URLSession, task: URLSessionTask, willBeginDelayedRequest request: URLRequest, completionHandler: @escaping (URLSession.DelayedRequestDisposition, URLRequest?) -> Swift.Void) {
        print("XMLHTTPRequest urlSession( session: URLSession, task: \(task), willBeginDelayedRequest: \(request), completionHandler: \(completionHandler) )")
    }
    
    @available(iOS 11.0, *)
    public func urlSession(_ session: URLSession, taskIsWaitingForConnectivity task: URLSessionTask) {
        print("XMLHTTPRequest urlSession( session: URLSession, taskIsWaitingForConnectivity: \(task) )")
    }
    
    public func urlSession(_ session: URLSession, task: URLSessionTask, willPerformHTTPRedirection response: HTTPURLResponse, newRequest request: URLRequest, completionHandler: @escaping (URLRequest?) -> Swift.Void) {
        print("XMLHTTPRequest urlSession( session: URLSession, task: \(task), willPerformHTTPRedirection: \(response), newRequest: \(request), completionHandler: \(completionHandler) )")
    }
    
    public func urlSession(_ session: URLSession, task: URLSessionTask, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Swift.Void) {
        print("XMLHTTPRequest urlSession( session: URLSession, task: \(task), didReceive: \(challenge), completionHandler: \(completionHandler) )")
    }
    
    public func urlSession(_ session: URLSession, task: URLSessionTask, needNewBodyStream completionHandler: @escaping (InputStream?) -> Swift.Void) {
        print("XMLHTTPRequest urlSession( session: URLSession, task: \(task), needNewBodyStream completionHandler: \(completionHandler) )")
    }
    
    public func urlSession(_ session: URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
        print("XMLHTTPRequest urlSession( session: URLSession, task: \(task), didSendBodyData bytesSent: \(bytesSent), totalBytesSent: \(totalBytesSent), totalBytesExpectedToSend: \(totalBytesExpectedToSend) )")
    }
    
    @available(iOS 10.0, *)
    public func urlSession(_ session: URLSession, task: URLSessionTask, didFinishCollecting metrics: URLSessionTaskMetrics) {
        print("XMLHTTPRequest urlSession( session: URLSession, task: \(task), didFinishCollecting metrics: \(metrics) )")
    }
    
    public func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        print("XMLHTTPRequest urlSession( session: URLSession, task: \(task), didCompleteWithError: \(String(describing: error)) )")
    }
    
}

// MARK: URLSessionDataDelegate

extension XMLHTTPRequest: URLSessionDataDelegate {
    
    public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Swift.Void) {
        print("XMLHTTPRequest urlSession( session: URLSession, dataTask: \(dataTask), didReceive: \(response), completionHandler: \(completionHandler) )")
    }
    
    public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didBecome downloadTask: URLSessionDownloadTask) {
        print("XMLHTTPRequest urlSession( session: URLSession, dataTask: \(dataTask), didBecome downloadTask: \(downloadTask) )")
    }
    
    @available(iOS 9.0, *)
    public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didBecome streamTask: URLSessionStreamTask) {
        print("XMLHTTPRequest urlSession( session: URLSession, dataTask: \(dataTask), didBecome streamTask: \(streamTask) )")
    }
    
    public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        print("XMLHTTPRequest urlSession( session: URLSession, dataTask: \(dataTask), didReceive: \(data) )")
    }
    
    public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, willCacheResponse proposedResponse: CachedURLResponse, completionHandler: @escaping (CachedURLResponse?) -> Swift.Void) {
        print("XMLHTTPRequest urlSession( session: URLSession, dataTask: \(dataTask), willCacheResponse: \(proposedResponse), completionHandler: \(completionHandler) )")
    }
    
}
