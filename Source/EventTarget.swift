//
//  EventTarget.swift
//  JavaScriptCoreBrowserObjectModel
//
//  Created by Connor Grady on 11/15/17.
//  Copyright © 2017 Connor Grady. All rights reserved.
//

import JavaScriptCore
import Foundation

public typealias Event = String

// SPEC: https://developer.mozilla.org/en-US/docs/Web/API/EventTarget
@objc public protocol EventTargetJSProtocol: JSExport {
    func addEventListener(_ event: Event!, _ listener: JSValue!/*EventListener!*/) -> Void
    func removeEventListener(_ event: Event!, _ listener: JSValue!/*EventListener!*/) -> Void
    func dispatchEvent(_ event: Event!) -> Bool
    // private
    //var listeners: [String: [EventHandler]] { get set }
}

@objc public class EventTarget: NSObject, EventTargetJSProtocol {
    
    private var _eventListeners = [Event: [( eventListener: EventListener, options: EventListenerOptions? )]]()
    
    public func addEventListener(_ event: Event!, _ listener: JSValue!/*EventListener!*/) -> Void {
        print("EventTarget addEventListener( event: \(event), listener: \(listener) )")
        if _eventListeners[event] == nil {
            _eventListeners[event] = [( eventListener: EventListener, options: EventListenerOptions? )]()
        }
        _eventListeners[event]!.append(( eventListener: listener, options: /*options*/nil ))
        return
    }
    
    public func removeEventListener(_ event: Event!, _ listener: JSValue!/*EventListener!*/) -> Void {
        print("EventTarget removeEventListener( event: \(event), listener: \(listener) )")
        if var eventListeners = _eventListeners[event] {
            //if let listenerIdx = eventListeners.index(where: { listener! == $0.eventListener }) {
            if let listenerIdx = eventListeners.index(where: { unsafeBitCast(listener, to: AnyObject.self) === unsafeBitCast($0.eventListener, to: AnyObject.self) }) {
                eventListeners.remove(at: listenerIdx)
            }
        }
        return
    }
    
    public func dispatchEvent(_ event: Event!) -> Bool {
        print("EventTarget dispatchEvent( \(String(stringLiteral: event)) )")
        if let eventListener = value(forKey: "on\(String(stringLiteral: event))") as? EventListener {
            //eventListener()
            eventListener.call(withArguments: [])
        }
        if var eventListeners = _eventListeners[event] {
            print("  eventListeners: \(eventListeners)")
            eventListeners.forEach({ (eventListener, options) in
                //eventListener()
                eventListener.call(withArguments: [])
            })
            while let removeIdx = eventListeners.index(where: { $0.options?.once == true }) {
                eventListeners.remove(at: removeIdx)
            }
        }
        return true
    }
    
}



//public typealias EventListener = () -> Void
//public typealias EventListener = @convention(block) () -> ()
public typealias EventListener = JSValue

@objc public protocol EventListenerOptions {
    var capture: Bool { get set }
    var once: Bool { get set }
    var passive: Bool { get set }
}
