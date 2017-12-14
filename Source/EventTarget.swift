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
@objc public protocol EventTarget: JSExport {
    func addEventListener(type: Event!, listener: EventListener!, options: EventListenerOptions?, useCapture: Bool) -> Void
    func removeEventListener(type: Event!, listener: EventListener!, options: EventListenerOptions?, useCapture: Bool) -> Void
    func dispatchEvent(event: Event!) -> Bool
    // private
    //var listeners: [String: [EventHandler]] { get set }
}

/*
// MARK: Default Method Implementations

extension EventTarget {
    @objc public func addEventListener(type: Event!, listener: EventListener!, options: EventListenerOptions?, useCapture: Bool) -> Void {
        print("EventTarget addEventListener( type: \(type), listener: \(listener), options: \(String(describing: options)), useCapture: \(useCapture) )")
    }
    @objc public func removeEventListener(type: Event!, listener: EventListener!, options: EventListenerOptions?, useCapture: Bool) -> Void {
        print("EventTarget removeEventListener( type: \(type), listener: \(listener), options: \(String(describing: options)), useCapture: \(useCapture) )")
    }
    @objc public func dispatchEvent(event: Event!) -> Bool {
        print("EventTarget dispatchEvent( \(event) )")
        return true
    }
}
*/



public typealias EventListener = () -> Void

@objc public protocol EventListenerOptions {
    var capture: Bool { get set }
    var once: Bool { get set }
    var passive: Bool { get set }
}
