//
//  URLSessionDelegateProxy.swift
//  JavaScriptCoreBrowserObjectModel
//
//  Created by Connor Grady on 1/20/18.
//  Copyright © 2018 Connor Grady. All rights reserved.
//

import Foundation

class URLSessionDelegateProxy: NSObject {
    
    weak var target: URLSessionDelegate?
    
    init(target: URLSessionDelegate? = nil) {
        super.init()
        self.target = target
    }
    
    override func forwardingTarget(for aSelector: Selector!) -> Any? {
        return target
    }
    
}

extension URLSessionDelegateProxy: URLSessionDelegate {
    
    /*
    @available(iOS 7.0, *)
    func urlSession(_ session: URLSession, didBecomeInvalidWithError error: Error?) {
        target?.urlSession?(session, didBecomeInvalidWithError: error)
    }
    
    @available(iOS 7.0, *)
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Swift.Void) {
        //target?.urlSession?(session, didReceive: challenge, completionHandler: completionHandler)
        guard let target = target, target.responds(to: #function) else {
            completionHandler(.performDefaultHandling, nil)
            return
        }
        target.urlSession!(session, didReceive: challenge, completionHandler: completionHandler)
    }
    
    @available(iOS 7.0, *)
    func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
        target?.urlSessionDidFinishEvents?(forBackgroundURLSession: session)
    }
    */
}

extension URLSessionDelegateProxy: URLSessionTaskDelegate {
    
    /*
    @available(iOS 11.0, *)
    func urlSession(_ session: URLSession, task: URLSessionTask, willBeginDelayedRequest request: URLRequest, completionHandler: @escaping (URLSession.DelayedRequestDisposition, URLRequest?) -> Swift.Void)
    
    @available(iOS 11.0, *)
    func urlSession(_ session: URLSession, taskIsWaitingForConnectivity task: URLSessionTask)
    
    @available(iOS 7.0, *)
    func urlSession(_ session: URLSession, task: URLSessionTask, willPerformHTTPRedirection response: HTTPURLResponse, newRequest request: URLRequest, completionHandler: @escaping (URLRequest?) -> Swift.Void)
    
    @available(iOS 7.0, *)
    func urlSession(_ session: URLSession, task: URLSessionTask, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Swift.Void)
    
    @available(iOS 7.0, *)
    func urlSession(_ session: URLSession, task: URLSessionTask, needNewBodyStream completionHandler: @escaping (InputStream?) -> Swift.Void)
    
    @available(iOS 7.0, *)
    func urlSession(_ session: URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64)
    
    @available(iOS 10.0, *)
    func urlSession(_ session: URLSession, task: URLSessionTask, didFinishCollecting metrics: URLSessionTaskMetrics)
    
    @available(iOS 7.0, *)
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?)
    */
}

extension URLSessionDelegateProxy: URLSessionDataDelegate {
    
    /*
    @available(iOS 7.0, *)
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Swift.Void)
    
    @available(iOS 7.0, *)
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didBecome downloadTask: URLSessionDownloadTask)
    
    @available(iOS 9.0, *)
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didBecome streamTask: URLSessionStreamTask)
    
    @available(iOS 7.0, *)
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data)
    
    @available(iOS 7.0, *)
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, willCacheResponse proposedResponse: CachedURLResponse, completionHandler: @escaping (CachedURLResponse?) -> Swift.Void)
    */
}

extension URLSessionDelegateProxy: URLSessionDownloadDelegate {
    
    // REQUIRED
    @available(iOS 7.0, *)
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        //target?.urlSession?(session, downloadTask: downloadTask, didFinishDownloadingTo: location)
        if let target = target as? URLSessionDownloadDelegate {
            target.urlSession(session, downloadTask: downloadTask, didFinishDownloadingTo: location)
        }
    }
    
    /*
    @available(iOS 7.0, *)
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64)
    
    @available(iOS 7.0, *)
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didResumeAtOffset fileOffset: Int64, expectedTotalBytes: Int64)
    */
}

extension URLSessionDelegateProxy: URLSessionStreamDelegate {
    
    /*
    @available(iOS 9.0, *)
    func urlSession(_ session: URLSession, readClosedFor streamTask: URLSessionStreamTask)
    
    @available(iOS 9.0, *)
    func urlSession(_ session: URLSession, writeClosedFor streamTask: URLSessionStreamTask)
    
    @available(iOS 9.0, *)
    func urlSession(_ session: URLSession, betterRouteDiscoveredFor streamTask: URLSessionStreamTask)
    
    @available(iOS 9.0, *)
    func urlSession(_ session: URLSession, streamTask: URLSessionStreamTask, didBecome inputStream: InputStream, outputStream: OutputStream)
    */
}
