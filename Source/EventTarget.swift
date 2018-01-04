//
//  EventTarget.swift
//  JavaScriptCoreBrowserObjectModel
//
//  Created by Connor Grady on 11/15/17.
//  Copyright © 2017 Connor Grady. All rights reserved.
//

import JavaScriptCore
import Foundation

// SPEC: https://developer.mozilla.org/en-US/docs/Web/API/EventTarget
@objc public protocol EventTargetJSProtocol: JSExport {
    func addEventListener(_ event: String!, _ listener: JSValue!, _ options: JSValue?) -> Void
    func removeEventListener(_ event: String!, _ listener: JSValue!, _ options: JSValue?) -> Void
    func dispatchEvent(_ event: String!) -> Bool
}

@objc public class EventTarget: NSObject, EventTargetJSProtocol {
    
    private var _eventListeners = [String: [( eventListener: EventListener, options: EventListenerOptions? )]]()
    
    public func addEventListener(_ event: String!, _ listener: JSValue!, _ options: JSValue? = nil) -> Void {
        let context = (JSContext.current() ?? listener.context)!
        //if var options = options {
        //    if options.isBoolean {
        //        options = JSValue(object: ( capture: options.toBool(), once: false, passive: false ), in: JSContext.current())
        //    } else if /*options is EventListenerOptions*/options.isObject {
        //        // ...
        //    }
        //}
        if _eventListeners[event] == nil {
            _eventListeners[event] = [( eventListener: EventListener, options: EventListenerOptions? )]()
        }
        //_eventListeners[event]!.append(( eventListener: listener, options: /*options*/nil ))
        let managedValue = JSManagedValue(value: listener)!
        JSContext.current().virtualMachine.addManagedReference(managedValue, withOwner: self)
        _eventListeners[event]!.append(( eventListener: managedValue, options: /*options*/nil ))
        return
    }
    
    public func removeEventListener(_ event: String!, _ listener: JSValue!, _ options: JSValue? = nil) -> Void {
        if var eventListeners = _eventListeners[event] {
            if let listenerIdx = eventListeners.index(where: { listener == $0.eventListener.value }) {
                let removed = eventListeners.remove(at: listenerIdx)
                let virtualMachine = removed.eventListener.value.context.virtualMachine
                virtualMachine?.removeManagedReference(removed.eventListener, withOwner: self)
            }
        }
        return
    }
    
    @discardableResult
    public func dispatchEvent(_ event: String!) -> Bool {
        if let eventListener = value(forKey: "on\(String(stringLiteral: event))") as? EventListener {
            eventListener.value.call(withArguments: [])
        }
        if var eventListeners = _eventListeners[event] {
            eventListeners.forEach({ (eventListener, options) in
                eventListener.value.call(withArguments: [])
            })
            while let removeIdx = eventListeners.index(where: { $0.options?.once == true }) {
                let removed = eventListeners.remove(at: removeIdx)
                let virtualMachine = removed.eventListener.value.context.virtualMachine
                virtualMachine?.removeManagedReference(removed.eventListener, withOwner: self)
            }
        }
        return true
    }
    
}



//public typealias EventListener = () -> Void
//public typealias EventListener = @convention(block) () -> ()
//public typealias EventListener = JSValue
public typealias EventListener = JSManagedValue

@objc public protocol EventListenerOptions {
    var capture: Bool { get set }
    var once: Bool { get set }
    var passive: Bool { get set }
}
