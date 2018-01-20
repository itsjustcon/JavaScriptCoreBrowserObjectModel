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
    //init()
    func addEventListener(_ event: String!, _ listener: JSValue!, _ options: JSValue?) -> Void
    func removeEventListener(_ event: String!, _ listener: JSValue!, _ options: JSValue?) -> Void
    func dispatchEvent(_ event: String!) -> Bool
}

@objc public class EventTarget: NSObject, EventTargetJSProtocol {
    
    //private weak var context: JSContext?
    
    //public override init() {
    //    super.init()
    //    context = JSContext.current()
    //}
    
    deinit {
        print("EventTarget deinit")
    }
    
    private var _eventListeners = [String: [( eventListener: EventListener, options: EventListenerOptions? )]]()
    
    public func addEventListener(_ event: String!, _ listener: JSValue!, _ options: JSValue? = nil) -> Void {
        print("EventTarget addEventListener( event: \(event), listener: \(listener), options: \(String(describing: options)) )")
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
            _eventListeners[event] = [( eventListener: EventListener, options: EventListenerOptions? )]()
        }
        //_eventListeners[event]!.append(( eventListener: listener, options: /*options*/nil ))
        //let managedValue = JSManagedValue(value: listener, andOwner: self)!
        let managedValue = JSManagedValue(value: listener)!
        context.virtualMachine.addManagedReference(managedValue, withOwner: self)
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
    
    //@discardableResult
    //func removeEventListener(_ listener: EventListener) -> Bool {}
    //@discardableResult
    //func removeEventListener(_ event: String, _ listener: EventListener) -> Bool {}
    @discardableResult
    func removeEventListener(_ event: String, _ index: Int) -> Bool {
        if var eventListeners = _eventListeners[event] {
            let removed = eventListeners.remove(at: index)
            if let listener = removed.eventListener.value as JSValue? {
                let virtualMachine = listener.context.virtualMachine
                virtualMachine?.removeManagedReference(removed.eventListener, withOwner: self)
            }
            return true
        }
        return false
    }
    
    @discardableResult
    private func removeReleasedEventListeners() -> UInt {
        var releaseCount: UInt = 0
        _eventListeners.forEach { (eventName, eventListeners) in
            while let removeIdx = eventListeners.index(where: { ($0.eventListener.value as JSValue?) == nil }) {
                //removeEventListener(event, eventListeners[removeIdx].eventListener)
                removeEventListener(eventName, removeIdx)
                releaseCount = releaseCount + 1
            }
        }
        return releaseCount
    }
    
    @discardableResult
    public func dispatchEvent(_ event: String!) -> Bool {
        removeReleasedEventListeners()
        if let eventListener = value(forKey: "on\(String(stringLiteral: event))") as? EventListener {
            eventListener.value.call(withArguments: [])
        }
        if let eventListeners = _eventListeners[event] {
            eventListeners.forEach({ (eventListener, options) in
                eventListener.value.call(withArguments: [])
                //if let listener = eventListener.value as JSValue? {
                //    listener.call(withArguments: [])
                //}
            })
            while let removeIdx = eventListeners.index(where: { $0.options?.once == true }) {
                //self.removeEventListener(event, eventListeners[removeIdx].eventListener)
                self.removeEventListener(event, removeIdx)
            }
        }
        return true
    }
    
}



//public typealias EventListener = () -> Void
//public typealias EventListener = (Event) -> Void
//public typealias EventListener = @convention(block) () -> Void
//public typealias EventListener = @convention(block) (Event) -> Void
//public typealias EventListener = JSValue
public typealias EventListener = JSManagedValue

@objc public protocol EventListenerOptions {
    var capture: Bool { get set }
    var once: Bool { get set }
    var passive: Bool { get set }
}
