//
//  TimersTests.swift
//  JavaScriptCoreBrowserObjectModel
//
//  Created by Connor Grady on 12/13/17.
//  Copyright © 2017 Connor Grady. All rights reserved.
//

import JavaScriptCore
import XCTest
@testable import JavaScriptCoreBrowserObjectModel

class TimersTests: XCTestCase {
    
    private func createContext() -> JSContext {
        let context = JSContext()!
        context.name = self.name
        context.exceptionHandler = { (ctx, val) in XCTFail("\(ctx?.name ?? self.name) exceptionHandler( \(String(describing: val)) )") }
        //context.setObject(Timers.self, forKeyedSubscript: "Timers" as (NSCopying & NSObjectProtocol))
        Timers.extend(context)
        return context
    }
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testGlobalDefinitions() {
        let context = createContext()
        XCTAssert(!context.objectForKeyedSubscript("setTimeout").isUndefined, "setTimeout should not be undefined")
        XCTAssert(!context.objectForKeyedSubscript("clearTimeout").isUndefined, "clearTimeout should not be undefined")
        XCTAssert(!context.objectForKeyedSubscript("setInterval").isUndefined, "setInterval should not be undefined")
        XCTAssert(!context.objectForKeyedSubscript("clearInterval").isUndefined, "clearInterval should not be undefined")
    }
    
    func testSetTimeout() {
        let context = createContext()
        
        let callbackExpectation = XCTestExpectation(description: "Invoke callback")
        let callback: @convention(block) () -> Void = {
            callbackExpectation.fulfill()
        }
        
        context.setObject(callback, forKeyedSubscript: "callback" as (NSCopying & NSObjectProtocol))
        let timerId = context.evaluateScript("setTimeout(callback, 1 * 1000)")
        // also works:
        //let setTimeout = context.objectForKeyedSubscript("setTimeout")!
        //let timerId = setTimeout.call(withArguments: [ JSValue(object: callback, in: context)!, 1 * 1000 ])
        
        XCTAssertNotNil(timerId, "setTimeout() should return a number")
        XCTAssert(timerId!.isNumber, "setTimeout() should return a number")
        XCTAssertGreaterThan(timerId!.toNumber().intValue, 0, "setTimeout() should return a positive number")
        
        wait(for: [ callbackExpectation ], timeout: 1)
    }
    
    func testClearTimeout() {
        let context = createContext()
        
        let callbackExpectation = XCTestExpectation(description: "Invoke callback")
        let successCallback: @convention(block) () -> Void = {
            callbackExpectation.fulfill()
        }
        let failureCallback: @convention(block) () -> Void = {
            XCTFail("Cancelled timer was invoked")
        }
        
        context.setObject(successCallback, forKeyedSubscript: "successCallback" as (NSCopying & NSObjectProtocol))
        context.setObject(failureCallback, forKeyedSubscript: "failureCallback" as (NSCopying & NSObjectProtocol))
        let timerId = context.evaluateScript("setTimeout(failureCallback, 0.5 * 1000)")!.toNumber().intValue
        context.evaluateScript("setTimeout(successCallback, 1 * 1000)")
        // also works:
        //let setTimeout = context.objectForKeyedSubscript("setTimeout")!
        //let timerId = setTimeout.call(withArguments: [ JSValue(object: failureCallback, in: context)!, 0.5 * 1000 ])!.toNumber().intValue
        //setTimeout.call(withArguments: [ JSValue(object: successCallback, in: context)!, 1 * 1000 ])
        
        context.evaluateScript("clearTimeout( \(timerId) )")
        
        wait(for: [ callbackExpectation ], timeout: 1)
    }
    
}
