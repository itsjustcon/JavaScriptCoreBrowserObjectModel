//
//  JSValue+Extensions.swift
//  JavaScriptCoreBrowserObjectModel
//
//  Created by Connor Grady on 11/16/17.
//  Copyright © 2017 Connor Grady. All rights reserved.
//

import JavaScriptCore
import Foundation

public extension JSValue {
    
    //open func setObject(_ object: Any!, forKeyedSubscript key: String!) {
    //    return self.setObject(object, forKeyedSubscript: key as (NSCopying & NSObjectProtocol))
    //}
    
    var isFunction: Bool {
        guard isObject else { return false }
        return JSObjectIsFunction(context.jsGlobalContextRef, jsValueRef)
    }
    
    @discardableResult
    func callAsync(withArguments arguments: [Any]!, completionHandler: @escaping (JSValue?, JSValue?) -> Void) -> JSValue! {
        var retVal = call(withArguments: arguments)!
        if retVal.isPromise {
            let fulfilledHandler: @convention(block) (JSValue?) -> Void = { value in
                completionHandler(value, nil)
            }
            let rejectedHandler: @convention(block) (JSValue?/*Error*/) -> Void = { error in
                completionHandler(nil, error)
            }
            //retVal = retVal.invokeMethod("then", withArguments: [ fulfilledHandler, rejectedHandler ])
            retVal = retVal.invokeMethod("then", withArguments: [ JSValue(object: fulfilledHandler, in: context), JSValue(object: rejectedHandler, in: context) ])
        } else {
            completionHandler(retVal, nil)
        }
        return retVal
    }
    
}
