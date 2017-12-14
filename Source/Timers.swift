//
//  Timers.swift
//  JavaScriptCoreBrowserObjectModel
//
//  Created by Connor Grady on 10/7/17.
//  Copyright © 2017 Connor Grady. All rights reserved.
//

import Foundation
import JavaScriptCore

//@objc protocol TimerJSExport : JSExport {
//    func setTimeout(_ callback: JSValue, _ ms: Double) -> String
//    func clearTimeout(_ identifier: String)
//    func setInterval(_ callback: JSValue, _ ms: Double) -> String
//    func clearInterval(_ identifier: String)
//}

@objc open class Timers: NSObject {
    

    
    //
    // General
    //
    
    //public class var count: Int { return timers.count }
    
    //public class func destroy() {
    //    // TODO: iterate all `timers` & invalidate each
    //}
    
    // @usage:
    //   let context = JSContext()!
    //   Timers.extend(context)
    //   context.evaluateScript("setTimeout(done, 5 * 1000)") // `done()` is called after 5s
    open class func extend(_ jsContext: JSContext) {
        jsContext.setObject(setTimeout, forKeyedSubscript: "setTimeout" as (NSCopying & NSObjectProtocol))
        jsContext.setObject(clearTimeout, forKeyedSubscript: "clearTimeout" as (NSCopying & NSObjectProtocol))
        jsContext.setObject(setInterval, forKeyedSubscript: "setInterval" as (NSCopying & NSObjectProtocol))
        jsContext.setObject(clearInterval, forKeyedSubscript: "clearInterval" as (NSCopying & NSObjectProtocol))
    }
    
    
    
    //
    // JS Methods
    //
    
    // Timeout
    open static let setTimeout: @convention(block) (JSValue, Double) -> UInt = { (callback, delay) in
        return createTimer(callback: callback, delay: delay, repeats: false)
    }
    open static let clearTimeout: @convention(block) (UInt) -> Void = { (identifier) in
        invalidateTimer(identifier)
    }
    
    // Interval
    open static let setInterval: @convention(block) (JSValue, Double) -> UInt = { (callback, delay) in
        return createTimer(callback: callback, delay: delay, repeats: true)
    }
    open static let clearInterval: @convention(block) (UInt) -> Void = { (identifier) in
        invalidateTimer(identifier)
    }
    
    
    
    //
    // Internals
    //
    
    internal static var timers = [UInt: Timer]()
    internal static var prevTimerId: UInt = 0
    
    fileprivate struct TimerData {
        var id: UInt
        var callbackManagedValue: JSManagedValue
        var repeats: Bool
    }
    
    internal class func createTimer(callback: JSValue, delay: Double, repeats: Bool) -> UInt {
        let callbackManagedValue = JSManagedValue(value: callback)!
        let timerId = prevTimerId + 1
        prevTimerId = timerId
        let timer = Timer.scheduledTimer(
            timeInterval: delay/1000.0,
            target: self,
            selector: #selector(fireTimer(timer:)),
            userInfo: TimerData(id: timerId, callbackManagedValue: callbackManagedValue, repeats: repeats),
            repeats: repeats
        )
        /*
        // NOTE: the following implementation requires iOS 10, so we'll switch to it eventually
        let timer = Timer.scheduledTimer(withTimeInterval: delay/1000.0, repeats: repeats) { timer in
            let callback = callbackManagedValue.value
            guard callback?.call(withArguments: []) != nil else {
                // INFO: callback no-longer exists, or is not a function
                timer.invalidate()
                timers.removeValue(forKey: timerId)
                return
            }
            if !repeats {
                timers.removeValue(forKey: timerId)
            }
        }
        */
        callback.context.virtualMachine.addManagedReference(callbackManagedValue, withOwner: timer)
        timers[timerId] = timer
        return timerId
    }
    
    @objc internal class func fireTimer(timer: Timer) {
        let userInfo = timer.userInfo as! TimerData
        let callback = userInfo.callbackManagedValue.value
        guard callback?.call(withArguments: []) != nil else {
            // INFO: callback no-longer exists, or is not a function
            timer.invalidate()
            timers.removeValue(forKey: userInfo.id)
            return
        }
        if !userInfo.repeats {
            timers.removeValue(forKey: userInfo.id)
        }
    }
    
    internal class func invalidateTimer(_ identifier: UInt) {
        if let timer = timers.removeValue(forKey: identifier) {
            let userInfo = timer.userInfo as! TimerData
            let callbackManagedValue = userInfo.callbackManagedValue
            let callback = callbackManagedValue.value
            callback?.context.virtualMachine.removeManagedReference(callbackManagedValue, withOwner: timer)
            
            timer.invalidate()
        }
    }
    
    
    
}
