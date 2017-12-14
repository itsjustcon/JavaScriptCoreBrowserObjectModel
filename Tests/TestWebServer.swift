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
            return (method == nil || method!.uppercased() == reqMethod.uppercased()) && (path.lowercased() == reqPath.lowercased())
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
        super.init()
        
        addHandler(match: { (method, url, headers, path, query) -> GCDWebServerRequest?/*TestWebServerRequest?*/ in
            if let expectation = self.expectations.first(where: { $0.matcher(method, url, headers, path, query) }) {
                return TestWebServerRequest(method: method, url: url, headers: headers, path: path, query: query, expectation: expectation)
            } else {
                return nil
                //return GCDWebServerRequest(method: method, url: url, headers: headers, path: path, query: query)
            }
        }) { (request) in
            var response: GCDWebServerResponse? = nil
            if let request = request as? TestWebServerRequest {
                //request.expectation.fulfill()
                defer { request.expectation.fulfill() }
                response = GCDWebServerResponse(statusCode: 200)
                //response = GCDWebServerDataResponse(text: "")
            }
            return response
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
