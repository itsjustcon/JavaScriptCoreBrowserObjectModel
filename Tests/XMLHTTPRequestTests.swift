//
//  XMLHTTPRequestTests.swift
//  JavaScriptCoreBrowserObjectModel
//
//  Created by Connor Grady on 11/14/17.
//  Copyright © 2017 Connor Grady. All rights reserved.
//

import JavaScriptCore
import XCTest
@testable import JavaScriptCoreBrowserObjectModel
//@testable import JavaScriptCoreBrowserObjectModel.XMLHTTPRequest

class XMLHTTPRequestTests: XCTestCase {
    
    static var webServer = TestWebServer()
    var webServer: TestWebServer { return XMLHTTPRequestTests.webServer }
    
    override class func setUp() {
        super.setUp()
        webServer.start(withPort: 8080, bonjourName: nil)
    }
    override class func tearDown() {
        super.tearDown()
        webServer.stop()
    }
    
    private func createContext() -> JSContext {
        let context = JSContext()!
        context.name = self.name
        context.exceptionHandler = { (ctx, val) in XCTFail("\(ctx?.name ?? self.name) exceptionHandler( \(String(describing: val)) )") }
        context.setObject(XMLHTTPRequest.self, forKeyedSubscript: "XMLHTTPRequest" as (NSCopying & NSObjectProtocol))
        return context
    }
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        webServer.removeAllExpectations()
    }
    
    func testInit() {
        let context = createContext()
        let result = context.evaluateScript("new XMLHTTPRequest()")
        XCTAssert(!result!.isUndefined, "result must not be undefined")
        XCTAssert(result!.isInstance(of: XMLHTTPRequest.self), "result must be an instance of XMLHTTPRequest")
    }
    
    func testSend_Swift() {
        
        let context = createContext()
        
        let req = XMLHTTPRequest()
        let onreadystatechange: @convention(block) () -> Void = {
            print("onreadystatechange()")
        }
        //req.onreadystatechange = EventListener(value: JSValue(object: onreadystatechange, in: context))
        //XCTAssertNotNil(req.onreadystatechange, "onreadystatechange was not set")
        req.addEventListener("readystatechange", JSValue(object: onreadystatechange, in: context))
        req.open("GET", webServer.serverURL!.absoluteString)
        req.send(nil)
        
    }
    
    func testSend_JavaScript() {
        
        let context = createContext()
        
        /*
        context.evaluateScript("""
var req = new XMLHTTPRequest();
req.onreadystatechange = function() {
    if (this.readyState == 4 && this.status == 200) {
       // Typical action to be performed when the document is ready:
       //document.getElementById("demo").innerHTML = req.responseText;
    }
};
req.open("GET", "https://google.com", true);
req.send();
""")
        */
        
        context.evaluateScript("var req = new XMLHTTPRequest();")
        let req = context.objectForKeyedSubscript("req").toObjectOf(XMLHTTPRequest.self) as! XMLHTTPRequest
        
        let expectations: [XMLHTTPRequestReadyState: XCTestExpectation] = [
            //.UNSENT: XCTestExpectation(description: "XMLHTTPRequestReadyState.UNSENT"),
            .OPENED: XCTestExpectation(description: "XMLHTTPRequestReadyState.OPENED"),
            .HEADERS_RECEIVED: XCTestExpectation(description: "XMLHTTPRequestReadyState.HEADERS_RECEIVED"),
            .LOADING: XCTestExpectation(description: "XMLHTTPRequestReadyState.LOADING"),
            .DONE: XCTestExpectation(description: "XMLHTTPRequestReadyState.DONE"),
        ]
        
        let onreadystatechangeExpectation = XCTestExpectation(description: "Invoke req.onreadystatechange")
        let onreadystatechange: @convention(block) () -> Void = {
            //print("onreadystatechange() \(req.readyState.rawValue)")
            onreadystatechangeExpectation.fulfill()
            expectations[req.readyState]?.fulfill()
        }
        //req.onreadystatechange = EventListener(value: JSValue(object: onreadystatechange, in: context))
        //XCTAssertNotNil(req.onreadystatechange, "onreadystatechange was not set")
        req.addEventListener("readystatechange", JSValue(object: onreadystatechange, in: context))
        
        let receivedRequestExpectation = webServer.expect(path: "/")
        
        context.evaluateScript("req.open('GET', '\(webServer.serverURL!.absoluteString)', true);")
        context.evaluateScript("req.send();")
        
        wait(for: [ onreadystatechangeExpectation, receivedRequestExpectation ], timeout: 1)
        //wait(for: [ expectations[.OPENED]!, expectations[.HEADERS_RECEIVED]!, expectations[.LOADING]!, expectations[.DONE]! ], timeout: 1, enforceOrder: true)
    }
    
    func testEventListeners() {
        
        let context = createContext()
        
        context.evaluateScript("var req = new XMLHTTPRequest();")
        //let req = context.objectForKeyedSubscript("req").toObjectOf(XMLHTTPRequest.self) as! XMLHTTPRequest
        
        let callbackExpectation = XCTestExpectation(description: "Invoke callback")
        let callback: @convention(block) () -> Void = {
            callbackExpectation.fulfill()
        }
        context.setObject(callback, forKeyedSubscript: "callback" as (NSCopying & NSObjectProtocol))
        
        context.evaluateScript("req.addEventListener('error', callback)")
        context.evaluateScript("req.dispatchEvent('error')")
        
        wait(for: [ callbackExpectation ], timeout: 1)
        
    }
    
}
