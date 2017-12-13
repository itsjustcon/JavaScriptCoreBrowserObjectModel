//
//  JavaScriptCoreBrowserObjectModelTests.swift
//  JavaScriptCoreBrowserObjectModelTests
//
//  Created by Connor Grady on 11/14/17.
//  Copyright © 2017 Connor Grady. All rights reserved.
//

import JavaScriptCore
import XCTest
@testable import JavaScriptCoreBrowserObjectModel

class JavaScriptCoreBrowserObjectModelTests: XCTestCase {
    
    let contextGroup = JSContextGroupCreate()
    lazy var globalContext: JSGlobalContextRef! = { [unowned self] in
        return JSGlobalContextCreateInGroup(self.contextGroup, nil)
    }()
    lazy var globalObject: JSObjectRef! = { [unowned self] in
        return JSContextGetGlobalObject(self.globalContext)
    }()
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        
        JSGarbageCollect(globalContext)
        
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        
        
        var exception: JSValueRef?
        
        /*
        func ObjectCallAsFunctionCallback(ctx: JSContextRef?, function: JSObjectRef?, thisObject: JSObjectRef?, argumentCount: Int, arguments: UnsafePointer<JSValueRef?>?, exception: UnsafeMutablePointer<JSValueRef?>?) -> JSValueRef? {
            print("Hello World")
            return JSValueMakeUndefined(ctx);
        }
        let functionObject = JSObjectMakeFunctionWithCallback(globalContext, JSStringCreateWithUTF8CString("log"), ObjectCallAsFunctionCallback);
        //let functionObject = JSObjectMakeFunctionWithCallback(globalContext, JSStringCreateWithUTF8CString("log")) { (ctx, function, thisObject, argumentCount, arguments, exception) -> JSValueRef? in
        //    print("Hello World")
        //    return JSValueMakeUndefined(ctx);
        //}
        
        JSObjectSetProperty(globalContext, globalObject, JSStringCreateWithUTF8CString("log"), functionObject, JSPropertyAttributes(kJSPropertyAttributeNone), nil);
        JSEvaluateScript(globalContext, JSStringCreateWithUTF8CString("log()"), nil, nil, 1, nil);
        */
        
        
        
        var jsClassDefinition = JSClassDefinition(
            version: 0,
            attributes: UInt32(kJSClassAttributeNone),
            className: "MyClass",
            //className: &("MyClass".utf8),
            parentClass: nil,
            //parentClass: kJSClassDefinitionEmpty as JSClassDefinition,
            staticValues: nil,
            staticFunctions: nil,
            initialize: { (ctx, object) in
                print("initialize( object: \(String(describing: object)) )")
            },
            finalize: { (object) in
                print("finalize( \(String(describing: object)) )")
            },
            hasProperty: nil,
            getProperty: nil,
            setProperty: nil,
            deleteProperty: nil,
            getPropertyNames: nil,
            callAsFunction: { (ctx, function, thisObject, argumentCount, arguments, exception) -> JSValueRef? in
                print("callAsFunction( function: \(String(describing: function)), thisObject: \(String(describing: thisObject)), arguments: \(String(describing: arguments)) )")
                return JSValueMakeUndefined(ctx);
            },
            callAsConstructor: { (ctx, constructor, argumentCount, arguments, exception) -> JSValueRef? in
                print("callAsConstructor( constructor: \(String(describing: constructor)), arguments: \(String(describing: arguments)) )")
                //let jsClass = JSClassCreate(&jsClassDefinition)
                //return JSObjectMake(ctx, jsClass, nil)
                //return nil
                return JSValueMakeUndefined(ctx)
            },
            hasInstance: nil,
            convertToType: nil)
        /*
        var jsClassDefinition: JSClassDefinition = kJSClassDefinitionEmpty
        //jsClassDefinition.className = &("MyClass")
        jsClassDefinition.className = &JSStringCreateWithUTF8CString("MyConstructor")
        //jsClassDefinition.className = &name
        //JSStringCreateWithUTF8CString("log")
        jsClassDefinition.callAsConstructor = { (ctx, constructor, argumentCount, arguments, exception) -> JSValueRef? in
            print("callAsConstructor( constructor: \(String(describing: constructor)), arguments: \(String(describing: arguments)) )")
            //let jsClass = JSClassCreate(&jsClassDefinition)
            //return JSObjectMake(ctx, jsClass, nil)
            //return nil
            return JSValueMakeUndefined(ctx)
        }
        jsClassDefinition.callAsFunction = { (ctx, function, thisObject, argumentCount, arguments, exception) -> JSValueRef? in
            print("callAsFunction( function: \(String(describing: function)), thisObject: \(String(describing: thisObject)), arguments: \(String(describing: arguments)) )")
            return JSValueMakeUndefined(ctx);
        }
        jsClassDefinition.finalize = { (object) in
            print("finalize( \(String(describing: object)) )")
        }
        */
        
        let jsClass = JSClassCreate(&jsClassDefinition)
        //JSClassRetain(jsClass)
        //JSObjectSetProperty(globalContext, globalObject, JSStringCreateWithUTF8CString(jsClassDefinition.className), jsClass, JSPropertyAttributes(kJSPropertyAttributeNone), nil)
        JSObjectSetProperty(globalContext, globalObject, JSStringCreateWithUTF8CString("MyClass"), jsClass, JSPropertyAttributes(kJSPropertyAttributeNone), nil)
        
        /*
        let jsConstructor = JSObjectMakeConstructor(globalContext, jsClass, nil)
        //let jsConstructor = JSObjectMakeConstructor(globalContext, jsClass, { (ctx, constructor, argumentCount, arguments, exception) -> JSValueRef? in
        //    print("callAsConstructor( constructor: \(String(describing: constructor)), arguments: \(String(describing: arguments)) )")
        //    return JSObjectMake(ctx, jsClass, nil)
        //    //return JSValueMakeUndefined(ctx)
        //})
        JSObjectSetProperty(globalContext, globalObject, JSStringCreateWithUTF8CString(jsClassDefinition.className), jsConstructor, JSPropertyAttributes(kJSPropertyAttributeNone), nil);
        */
        
        /*
        //JSEvaluateScript(globalContext, JSStringCreateWithUTF8CString("new MyConstructor()"), nil, nil, 1, nil);
        ////JSEvaluateScript(globalContext, JSStringCreateWithUTF8CString("MyConstructor()"), nil, nil, 1, nil);
        //JSEvaluateScript(globalContext, JSStringCreateWithUTF8CString("new MyConstructor()"), nil, nil, 0, &exception)
        ////JSEvaluateScript(globalContext, JSStringCreateWithUTF8CString("MyConstructor()"), nil, nil, 0, &exception)
        JSEvaluateScript(self.globalContext, JSStringCreateWithUTF8CString("new MyClass()"), nil, nil, 0, &exception)
        //JSEvaluateScript(globalContext, JSStringCreateWithUTF8CString("MyClass()"), nil, nil, 0, &exception)
        
        //JSClassRelease(jsClass)
        
        //XCTAssertNil(exception)
        */
        
        let context = JSContext()!
        context.exceptionHandler = { context, exception in
            print("context.exceptionHandler()\n\(String(describing: exception))")
            XCTAssertNil(exception)
        }
        
        print("jsClassDefinition.className: \(String(cString: jsClassDefinition.className))")
        
        //context.setObject(jsClass, forKeyedSubscript: "MyClass" as (NSCopying & NSObjectProtocol))
        
        //let jsConstructor = JSObjectSetProperty(context.jsGlobalContextRef, context.globalObject.jsValueRef, JSStringCreateWithUTF8CString(jsClassDefinition.className), jsClass, JSPropertyAttributes(kJSPropertyAttributeNone), nil)
        //let jsConstructor = JSObjectMakeConstructor(context.jsGlobalContextRef, jsClass, nil)
        //context.setObject(jsConstructor, forKeyedSubscript: "MyClass" as (NSCopying & NSObjectProtocol))
        
        let jsObject = JSObjectMake(context.jsGlobalContextRef, jsClass, nil)
        context.setObject(jsObject, forKeyedSubscript: "MyClass" as (NSCopying & NSObjectProtocol))
        
        context.evaluateScript("new MyClass()")
        //context.evaluateScript("MyClass()")
        
    }
    
}
