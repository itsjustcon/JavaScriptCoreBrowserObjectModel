//
//  JSPromise.swift
//  JavaScriptCoreBrowserObjectModel
//
//  Created by Connor Grady on 1/22/18.
//  Copyright © 2018 Connor Grady. All rights reserved.
//

import Foundation
import JavaScriptCore

//public typealias FulfilledHandler = (Any?) -> Any?
//public typealias RejectedHandler = (JSError?) -> Void
public typealias FulfilledHandler = @convention(block) (Any?) -> Any?
public typealias RejectedHandler = @convention(block) (JSError) -> Void

// SPEC: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Promise
@objc public protocol PromiseJSProtocol: JSExport {
    //init(_ resolver: JSValue)
    //init(_ resolver: @convention(block) (@convention(block) @escaping (Any?) -> Void, @convention(block) @escaping (JSError) -> Void) -> Void)
    init(_ resolver: @convention(block) (@escaping (Any?) -> Void, @escaping (JSError) -> Void) -> Void)
    //init(_ resolver: (@escaping (Any?) -> Void, @escaping (JSError) -> Void) -> Void)
    func then(_ onFulfilled: @escaping FulfilledHandler, _ onRejected: @escaping RejectedHandler) -> JSPromise
    func `catch`(_ onRejected: @escaping RejectedHandler) -> JSPromise
}

@objc public class JSPromise: NSObject, PromiseJSProtocol {
    
    // inspired by Bluebird (http://bluebirdjs.com/docs/api-reference.html)
    public class func resolve(_ value: Any? = nil) -> JSPromise {
        //return JSPromise({ (resolve, _) in
        //    resolve(value)
        //})
        return JSPromise({ (resolve, reject) in
            if let value = value as? JSPromise {
                value.then(resolve, reject)
            } else {
                resolve(value)
            }
        })
    }
    
    // inspired by Bluebird (http://bluebirdjs.com/docs/api-reference.html)
    public class func reject(_ reason: JSError) -> JSPromise {
        return JSPromise({ (_, reject) in
            reject(reason)
        })
    }
    
    // inspired by Bluebird (http://bluebirdjs.com/docs/api-reference.html)
    private(set) var value: Any?
    private(set) var reason: JSError?
    private(set) var isFulfilled = false
    var isRejected: Bool {
        return reason != nil
    }
    var isPending: Bool {
        return !isFulfilled && !isRejected
    }
    
    //public required init(_ resolver: (@escaping FulfilledHandler, @escaping RejectedHandler) -> Void) {
    //public required init(_ resolver: @convention(block) (@convention(block) @escaping (Any?) -> Void, @convention(block) @escaping (JSError) -> Void) -> Void) {
    public required init(_ resolver: @convention(block) (@escaping (Any?) -> Void, @escaping (JSError) -> Void) -> Void) {
    //public required init(_ resolver: (@escaping (Any?) -> Void, @escaping (JSError) -> Void) -> Void) {
        super.init()
        //resolver(
        //    { [weak self] value in self?.resolve(value) },
        //    { [weak self] error in self?.reject(error) }
        //)
        resolver({ self.resolve($0) }, { self.reject($0) })
        //let resolveFn: @convention(block) (Any?) -> Void = { self.resolve($0) }
        //let rejectFn: @convention(block) (JSError) -> Void = { self.reject($0) }
        //resolver(resolveFn, rejectFn)
    }
    
    internal var _fulfilledHandlers = [FulfilledHandler]()
    internal var _rejectedHandlers = [RejectedHandler]()
    
    internal func resolve(_ value: Any? = nil) {
        guard isPending else { return }
        
        // if `value` is a `Promise`, wait for it to resolve
        if let value = value as? JSPromise {
            value.then(
                { [weak self] value in self?.resolve(value) },
                { [weak self] error in self?.reject(error) }
            )
            return
        }
        
        self.value = value
        reason = nil
        isFulfilled = true
        
        _fulfilledHandlers.forEach { fulfilledHandler in
            let _ = fulfilledHandler(value)
        }
        //_fulfilledHandlers.forEach { let _ = $0(value) }
        
        _fulfilledHandlers.removeAll()
        _rejectedHandlers.removeAll()
    }
    internal func reject(_ reason: JSError) {
        guard isPending else { return }
        
        value = nil
        self.reason = reason
        isFulfilled = false
        
        _rejectedHandlers.forEach { rejectedHandler in
            rejectedHandler(reason)
        }
        //_rejectedHandlers.forEach { $0(reason) }
        
        _fulfilledHandlers.removeAll()
        _rejectedHandlers.removeAll()
    }
    
    @discardableResult
    public func then(_ onFulfilled: @escaping FulfilledHandler, _ onRejected: @escaping RejectedHandler = { _ in }) -> JSPromise {
        if isFulfilled {
            return JSPromise.resolve(onFulfilled(value))
        } else if isRejected {
            onRejected(reason!)
            return JSPromise.reject(reason!)
        } else {
            return JSPromise({ (resolve, reject) in
                _fulfilledHandlers.append({ value in
                    resolve(onFulfilled(value))
                })
                _rejectedHandlers.append({ error in
                    onRejected(error)
                    reject(error)
                })
            })
        }
    }
    
    @discardableResult
    public func `catch`(_ onRejected: @escaping RejectedHandler) -> JSPromise {
        return then({ $0 }, onRejected)
    }
    
}



public extension JSValue {
    
    var isPromise: Bool {
        guard isObject else { return false }
        if isInstance(of: JSPromise.self) { return true }
        /*
        let JSNativePromise = context.objectForKeyedSubscript("Promise")!
        guard JSNativePromise.isObject else { return false }
        //var jsException: JSValueRef? = nil
        return JSValueIsInstanceOfConstructor(context.jsGlobalContextRef, jsValueRef, JSNativePromise.jsValueRef, nil/*&jsException*/)
        */
        return (forProperty("then").isFunction && forProperty("catch").isFunction)
    }
    
    func toPromise() -> JSPromise {
        //guard isObject else { return nil }
        if isPromise {
            return toObjectOf(JSPromise.self) as! JSPromise
        }
        switch JSValueGetType(context.jsGlobalContextRef, jsValueRef) {
        case kJSTypeBoolean:
            return JSPromise.resolve(toBool())
        case kJSTypeNumber:
            return JSPromise.resolve(toNumber())
        case kJSTypeString:
            return JSPromise.resolve(toString())
        case kJSTypeObject:
            return JSPromise.resolve(toObject())
        //case kJSTypeUndefined:
        //case kJSTypeNull:
        default:
            return JSPromise.resolve(/*nil*/)
        }
    }
    
}
