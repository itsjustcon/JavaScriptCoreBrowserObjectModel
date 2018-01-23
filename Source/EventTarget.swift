//
//  EventTarget.swift
//  JavaScriptCoreBrowserObjectModel
//
//  Created by Connor Grady on 11/15/17.
//  Copyright © 2017 Connor Grady. All rights reserved.
//

import Foundation
import JavaScriptCore

// SPEC: https://developer.mozilla.org/en-US/docs/Web/API/EventTarget
@objc public protocol EventTargetJSProtocol: JSExport {
    func addEventListener(_ event: String!, _ listener: EventListener!, _ options: JSValue?) -> Void
    func removeEventListener(_ event: String!, _ listener: EventListener!, _ options: JSValue?) -> Void
    func dispatchEvent(_ event: String!) -> Bool
}

@objc public class EventTarget: NSObject, EventTargetJSProtocol {
    
    private var _eventListeners = [String: [( eventListener: EventListenerRef, options: EventListenerOptions? )]]()
    
    public func addEventListener(_ event: String!, _ listener: EventListener!, _ options: JSValue? = nil) -> Void {
        //let context = (JSContext.current() ?? listener.context)!
        let context = listener.context!
        //if var options = options {
        //    if options.isBoolean {
        //        options = JSValue(object: ( capture: options.toBool(), once: false, passive: false ), in: context)
        //    } else if /*options is EventListenerOptions*/options.isObject {
        //        // ...
        //    }
        //}
        if _eventListeners[event] == nil {
            _eventListeners[event] = [( eventListener: EventListenerRef, options: EventListenerOptions? )]()
        }
        let managedValue = JSManagedValue(value: listener)!
        context.virtualMachine.addManagedReference(managedValue, withOwner: self)
        _eventListeners[event]!.append(( eventListener: managedValue, options: /*options*/nil ))
        return
    }
    
    public func removeEventListener(_ event: String!, _ listener: EventListener!, _ options: JSValue? = nil) -> Void {
        if let eventListeners = _eventListeners[event] {
            if let listenerIdx = eventListeners.index(where: { listener == $0.eventListener.value }) {
                removeEventListener(event, listenerIdx)
            }
        }
        return
    }
    @discardableResult
    func removeEventListener(_ event: String, _ index: Int) -> Bool {
        if var eventListeners = _eventListeners[event] {
            let removed = eventListeners.remove(at: index)
            let virtualMachine = removed.eventListener.value.context.virtualMachine
            virtualMachine?.removeManagedReference(removed.eventListener, withOwner: self)
            return true
        }
        return false
    }
    
    @discardableResult
    public func dispatchEvent(_ event: String!) -> Bool {
        if let eventListener = value(forKey: "on\(String(stringLiteral: event))") as? EventListener {
            //eventListener.value.call(withArguments: [])
            let thisObject = JSValue(object: self, in: eventListener.context)!
            JSObjectCallAsFunction(eventListener.context.jsGlobalContextRef, eventListener.jsValueRef, thisObject.jsValueRef, 0, nil, nil)
        }
        if let eventListeners = _eventListeners[event] {
            eventListeners.forEach({ (eventListener, options) in
                //eventListener.value.call(withArguments: [])
                let listener = eventListener.value!
                let thisObject = JSValue(object: self, in: listener.context)!
                JSObjectCallAsFunction(listener.context.jsGlobalContextRef, listener.jsValueRef, thisObject.jsValueRef, 0, nil, nil)
            })
            while let removeIdx = eventListeners.index(where: { $0.options?.once == true }) {
                removeEventListener(event, removeIdx)
            }
        }
        return true
    }
    
    /*
    private func invokeEventListener(_ eventListener: EventListener, arguments: [JSValue] = []) -> Any? {
        //eventListener.value.call(withArguments: arguments)
        let listener = eventListener.value!
        let thisObject = JSValue(object: self, in: listener.context)!
        JSObjectCallAsFunction(listener.context.jsGlobalContextRef, listener.jsValueRef, thisObject.jsValueRef, 0, nil, nil)
        //let args = arguments.map { $0.jsValueRef }
        let args = JSValue(object: arguments, in: listener.context)
        let argsPtr: UnsafePointer<JSValueRef?> = (args != nil ? &(args!.jsValueRef) : nil)
        JSObjectCallAsFunction(<#T##ctx: JSContextRef!##JSContextRef!#>, <#T##object: JSObjectRef!##JSObjectRef!#>, <#T##thisObject: JSObjectRef!##JSObjectRef!#>, <#T##argumentCount: Int##Int#>, <#T##arguments: UnsafePointer<JSValueRef?>!##UnsafePointer<JSValueRef?>!#>, <#T##exception: UnsafeMutablePointer<JSValueRef?>!##UnsafeMutablePointer<JSValueRef?>!#>)
        let retVal = JSObjectCallAsFunction(<#T##ctx: JSContextRef!##JSContextRef!#>, <#T##object: JSObjectRef!##JSObjectRef!#>, <#T##thisObject: JSObjectRef!##JSObjectRef!#>, arguments.count, args?.jsValueRef, nil)
    }
    */
    
}



//public typealias EventListener = () -> Void
//public typealias EventListener = (Event) -> Void
//public typealias EventListener = @convention(block) () -> Void
//public typealias EventListener = @convention(block) (Event) -> Void
public typealias EventListener = JSValue
//public typealias EventListener = JSManagedValue
public typealias EventListenerRef = JSManagedValue

@objc public protocol EventListenerOptions {
    var capture: Bool { get set }
    var once: Bool { get set }
    var passive: Bool { get set }
}
