//
//  XMLHttpRequest.swift
//  JavaScriptCoreBrowserObjectModel
//
//  Created by Connor Grady on 11/14/17.
//  Copyright © 2017 Connor Grady. All rights reserved.
//

import Foundation
import JavaScriptCore

@objc protocol XMLHttpRequestJSProtocol: JSExport, XMLHttpRequestEventTarget {
    var readyState: XMLHttpRequestReadyState { get }
    var response: Any? { get }
    var responseText: String? { get }
    var responseType: XMLHttpRequestResponseType { get }
    //var responseType: String { get }
    var responseURL: String? { get }
    //var responseXML: Any? { get }
    var status: XMLHttpRequestStatus { get }
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
//extension XMLHttpRequestJSProtocol {
//    var responseType: XMLHttpRequestResponseType { get }
//}

@objc public class XMLHttpRequest: /*NSObject*/EventTarget, XMLHttpRequestJSProtocol {
    
    public var readyState: XMLHttpRequestReadyState = .UNSENT { // read-only
        didSet {
            //onreadystatechange?()
            //onreadystatechange?.value.call(withArguments: [])
            dispatchEvent("readystatechange")
        }
    }
    
    public var response: Any?
    public var responseText: String?
    public var responseType: XMLHttpRequestResponseType = .none //.text // NOTE: `.none` >> `.text`
    public var responseURL: String?
    //public var responseXML: Any?
    
    public var status: XMLHttpRequestStatus = 0 // read-only
    public var statusText: String? // read-only
    
    public var timeout: Int = 0
    
    //public var upload: XMLHttpRequestUpload // read-only
    
    public var withCredentials: Bool = false
    //public var withCredentials: Bool { return (_user != nil && _password != nil) } // read-only
    
    // MARK: Internal Variables
    //private var _urlSession: URLSession = URLSession.shared
    private lazy var _urlSession: URLSession = {
        //return URLSession(configuration: /*.default*/.ephemeral, delegate: self, delegateQueue: nil)
        return URLSession(configuration: /*.default*/.ephemeral, delegate: URLSessionDelegateProxy(target: self), delegateQueue: nil)
        //return URLSession(configuration: .background(withIdentifier: "JavaScriptCoreBrowserObjectModel.XMLHttpRequest"), delegate: self, delegateQueue: nil)
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
        if let context = JSContext.current() {
            context.virtualMachine.addManagedReference(self, withOwner: context)
        }
    }
    
    deinit {
        print("XMLHttpRequest deinit")
        //(_urlSession.delegate as? WeakURLSessionDelegate)?.target = nil
        _urlSession.invalidateAndCancel()
    }
    
    public func abort() -> Void {
        print("XMLHttpRequest abort()")
        
        _dataTask?.cancel()
        
        status = 0
        readyState = .DONE
        
        dispatchEvent("abort")
        
    }
    
    public func getAllResponseHeaders() -> String? {
        guard readyState.rawValue >= XMLHttpRequestReadyState.HEADERS_RECEIVED.rawValue,
            _responseHeaders.count > 0
            else { return nil }
        return _responseHeaders
            .filter({ (key, _) in ![ "set-cookie", "set-cookie2" ].contains(key.lowercased()) })
            .map({ (key, value) in "\(key): \(value)\r\n" })
            .joined(/*separator: "\r\n"*/)
        // NOTE: we can't use `separator` here b/c each header must end with CRLF,
        //       therefore the returned string must end with CRLF as well
    }
    public func getResponseHeader(_ name: String!) -> String? {
        //return _responseHeaders[name]
        //return _responseHeaders[name.lowercased()]
        return _responseHeaders.first(where: { $0.key.lowercased() == name.lowercased() })?.value
    }

    public func open(_ method: String!, _ url: String!, _ async: Bool = true, _ user: String? = nil, _ password: String? = nil) -> Void {
        print("XMLHttpRequest open( method: \(method), url: \(url), async: \(async), user: \(String(describing: user)), password: \(String(describing: password)) )")
        
        _request = URLRequest(url: URL(string: url)!)
        //_request = URLRequest(url: URL(string: url)!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: TimeInterval(timeout))
        _request!.httpMethod = method
        _async = async
        _user = user
        _password = password
        
        readyState = .OPENED
    }
    
    public func overrideMimeType(_ mimetype: String!) -> Void {
        print("XMLHttpRequest overrideMimeType( mimetype: \(mimetype) )")
    }
    
    public func send(_ body: JSValue?) -> Void {
        print("XMLHttpRequest send( \(String(describing: body)) )")
        
        //JSValueProtect(JSContext.current()!.jsGlobalContextRef, JSContext.currentThis().jsValueRef)
        //JSContext.current().virtualMachine.addManagedReference(self, withOwner: JSContext.current().jsGlobalContextRef)
        
        for (header, value) in _requestHeaders {
            _request!.setValue(value, forHTTPHeaderField: header)
        }
        //_request!.timeoutInterval = TimeInterval(timeout)
        if body != nil && body!.isString {
            _request!.httpBody = body!.toString().data(using: .utf8)
        }
        
        let dataTask = _urlSession.dataTask(with: _request!) /*{ (data, response, error) in
            print("_dataTask callback!!!")
            //self.readyState = .DONE
        }*/
        dataTask.resume()
        _dataTask = dataTask
    }
    
    public func setRequestHeader(_ header: String!, _ value: String!) -> Void {
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
    //    //willSet {
    //    //    if self.onreadystatechange != nil, let context = (JSContext.current() ?? listener.context) {
    //    //        context.virtualMachine.removeManagedReference(self.onreadystatechange!, withOwner: self)
    //    //    }
    //    //}
    //    didSet {
    //        if self.onreadystatechange != nil, let context = (JSContext.current() ?? listener.context) {
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

public typealias XMLHttpRequestStatus = Int
//public enum XMLHttpRequestStatus: Int {
//    case complete = 0
//    // HTTP Status Codes
//    case ok = 200
//}

// SPEC: https://developer.mozilla.org/en-US/docs/Web/API/XMLHttpRequest/readyState
@objc public enum XMLHttpRequestReadyState: Int {
    case UNSENT = 0
    case OPENED = 1
    case HEADERS_RECEIVED = 2
    case LOADING = 3
    case DONE = 4
}

@objc public enum XMLHttpRequestResponseType: Int, RawRepresentable {
    
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

extension XMLHttpRequest: URLSessionDelegate {
    
    //public func urlSession(_ session: URLSession, didBecomeInvalidWithError error: Error?) {
    //    print("XMLHttpRequest urlSession( session: \(session), didBecomeInvalidWithError: \(String(describing: error)) )")
    //}
    
    //public func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Swift.Void) {
    //    print("XMLHttpRequest urlSession( session: \(session), didReceive: \(challenge), completionHandler: \(completionHandler) )")
    //}
    
    //public func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
    //    print("XMLHttpRequest urlSessionDidFinishEvents( forBackgroundURLSession: \(session) )")
    //}
    
}

// MARK: URLSessionTaskDelegate

extension XMLHttpRequest: URLSessionTaskDelegate {
    
    //@available(iOS 11.0, *)
    //public func urlSession(_ session: URLSession, task: URLSessionTask, willBeginDelayedRequest request: URLRequest, completionHandler: @escaping (URLSession.DelayedRequestDisposition, URLRequest?) -> Swift.Void) {
    //    print("XMLHttpRequest urlSession( session: URLSession, task: \(task), willBeginDelayedRequest: \(request), completionHandler: \(completionHandler) )")
    //}
    
    //@available(iOS 11.0, *)
    //public func urlSession(_ session: URLSession, taskIsWaitingForConnectivity task: URLSessionTask) {
    //    print("XMLHttpRequest urlSession( session: URLSession, taskIsWaitingForConnectivity: \(task) )")
    //}
    
    //public func urlSession(_ session: URLSession, task: URLSessionTask, willPerformHTTPRedirection response: HTTPURLResponse, newRequest request: URLRequest, completionHandler: @escaping (URLRequest?) -> Swift.Void) {
    //    print("XMLHttpRequest urlSession( session: URLSession, task: \(task), willPerformHTTPRedirection: \(response), newRequest: \(request), completionHandler: \(completionHandler) )")
    //}
    
    //public func urlSession(_ session: URLSession, task: URLSessionTask, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Swift.Void) {
    //    print("XMLHttpRequest urlSession( session: URLSession, task: \(task), didReceive: \(challenge), completionHandler: \(completionHandler) )")
    //}
    
    //public func urlSession(_ session: URLSession, task: URLSessionTask, needNewBodyStream completionHandler: @escaping (InputStream?) -> Swift.Void) {
    //    print("XMLHttpRequest urlSession( session: URLSession, task: \(task), needNewBodyStream completionHandler: \(completionHandler) )")
    //}
    
    public func urlSession(_ session: URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
        print("XMLHttpRequest urlSession( session: URLSession, task: \(task), didSendBodyData bytesSent: \(bytesSent), totalBytesSent: \(totalBytesSent), totalBytesExpectedToSend: \(totalBytesExpectedToSend) )")
    }
    
    //@available(iOS 10.0, *)
    //public func urlSession(_ session: URLSession, task: URLSessionTask, didFinishCollecting metrics: URLSessionTaskMetrics) {
    //    print("XMLHttpRequest urlSession( session: URLSession, task: \(task), didFinishCollecting metrics: \(metrics) )")
    //}
    
    public func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        print("XMLHttpRequest urlSession( session: URLSession, task: \(task), didCompleteWithError: \(String(describing: error)) )")
        
        readyState = .DONE
        
        if error != nil {
            dispatchEvent("error")
        }
        
        dispatchEvent("loadend")
        
    }
    
}

// MARK: URLSessionDataDelegate

extension XMLHttpRequest: URLSessionDataDelegate {
    
    public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Swift.Void) {
        print("XMLHttpRequest urlSession( session: URLSession, dataTask: \(dataTask), didReceive: \(response), completionHandler: \(completionHandler) )")
        
        if let httpResponse = response as? HTTPURLResponse {
            status = httpResponse.statusCode
            _responseHeaders = (httpResponse.allHeaderFields as? [String: String]) ?? [:]
            readyState = .HEADERS_RECEIVED
        }
        
        completionHandler(.allow)
        
    }
    
    //public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didBecome downloadTask: URLSessionDownloadTask) {
    //    print("XMLHttpRequest urlSession( session: URLSession, dataTask: \(dataTask), didBecome downloadTask: \(downloadTask) )")
    //}
    
    //@available(iOS 9.0, *)
    //public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didBecome streamTask: URLSessionStreamTask) {
    //    print("XMLHttpRequest urlSession( session: URLSession, dataTask: \(dataTask), didBecome streamTask: \(streamTask) )")
    //}
    
    public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        print("XMLHttpRequest urlSession( session: URLSession, dataTask: \(dataTask), didReceive: \(data) )")
        
        if readyState == .HEADERS_RECEIVED {
            readyState = .LOADING
        }
        
    }
    
    //public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, willCacheResponse proposedResponse: CachedURLResponse, completionHandler: @escaping (CachedURLResponse?) -> Swift.Void) {
    //    print("XMLHttpRequest urlSession( session: URLSession, dataTask: \(dataTask), willCacheResponse: \(proposedResponse), completionHandler: \(completionHandler) )")
    //}
    
}
