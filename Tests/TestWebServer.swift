//
//  TestWebServer.swift
//  JavaScriptCoreBrowserObjectModel
//
//  Created by Connor Grady on 12/12/17.
//  Copyright © 2017 Connor Grady. All rights reserved.
//

import XCTest
import GCDWebServer

typealias TestWebServerMatchBlock = (_ method: String, _ url: URL, _ headers: [AnyHashable: Any], _ path: String, _ query: [AnyHashable: Any]) -> Bool

public class TestWebServerExpectation: XCTestExpectation {
    var matcher: TestWebServerMatchBlock!
    override init(description expectationDescription: String) {
        super.init(description: expectationDescription)
    }
    //convenience init(path: String) {
    //    self.init(description: "")
    //}
    convenience init(method: String? = nil, path: String) {
        self.init(description: "Request: [\(method ?? "ALL")] \(path)")
        matcher = { (reqMethod, reqUrl, reqHeaders, reqPath, reqQuery) -> Bool in
            return (method == nil || method == reqMethod) && (path == reqPath)
        }
    }
}

private class TestWebServerRequest: GCDWebServerRequest {
    var expectation: TestWebServerExpectation!
    //override init() {}
    //override init(method: String, url: URL, headers: [AnyHashable : Any], path: String, query: [AnyHashable : Any]?) {}
    init(method: String, url: URL, headers: [AnyHashable : Any], path: String, query: [AnyHashable : Any]?, expectation: TestWebServerExpectation) {
        super.init(method: method, url: url, headers: headers, path: path, query: query)
        self.expectation = expectation
    }
}

public class TestWebServer: GCDWebServer {
    
    private(set) var expectations = [TestWebServerExpectation]()
    
    override init() {
        print("TestWebServer init()")
        super.init()
        
        addHandler(match: { (method, url, headers, path, query) -> TestWebServerRequest? in
            print("TestWebServer match( method: \(method), url: \(url), headers: \(headers), path: \(path), query: \(query) )")
            if let expectation = self.expectations.first(where: { $0.matcher(method, url, headers, path, query) }) {
                return TestWebServerRequest(method: method, url: url, headers: headers, path: path, query: query, expectation: expectation)
            }
            return nil
        }) { (request/*: TestWebServerRequest*/) -> GCDWebServerResponse? in
            if let request = request as? TestWebServerRequest {
                defer { request.expectation.fulfill() }
                return GCDWebServerResponse(/*statusCode: 200*/)
                //return GCDWebServerDataResponse(text: "")
            }
            return nil
        }
        
    }
    
    @discardableResult
    func expect(method: String? = nil, path: String) -> TestWebServerExpectation {
        let expectation = TestWebServerExpectation(method: method, path: path)
        expectations.append(expectation)
        return expectation
    }
    
    func removeAllExpectations() {
        expectations.removeAll()
    }
    
}
