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
    
    override func responds(to aSelector: Selector!) -> Bool {
        return target?.responds(to: aSelector) ?? super.responds(to: aSelector)
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
        guard target != nil, target!.responds(to: #function) else {
            completionHandler(.performDefaultHandling, nil)
            return
        }
        target?.urlSession?(session, didReceive: challenge, completionHandler: completionHandler)
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
    func urlSession(_ session: URLSession, task: URLSessionTask, willBeginDelayedRequest request: URLRequest, completionHandler: @escaping (URLSession.DelayedRequestDisposition, URLRequest?) -> Swift.Void) {
        guard target != nil, target!.responds(to: #function) else {
            completionHandler(URLSession.DelayedRequestDisposition.continueLoading, nil)
            return
        }
        (target as? URLSessionTaskDelegate)?.urlSession?(session, task: task, willBeginDelayedRequest: request, completionHandler: completionHandler)
    }
    
    @available(iOS 11.0, *)
    func urlSession(_ session: URLSession, taskIsWaitingForConnectivity task: URLSessionTask) {
        (target as? URLSessionTaskDelegate)?.urlSession?(session, taskIsWaitingForConnectivity: task)
    }
    
    @available(iOS 7.0, *)
    func urlSession(_ session: URLSession, task: URLSessionTask, willPerformHTTPRedirection response: HTTPURLResponse, newRequest request: URLRequest, completionHandler: @escaping (URLRequest?) -> Swift.Void) {
        guard target != nil, target!.responds(to: #function) else {
            completionHandler(request)
            //completionHandler(nil)  // refuse the redirect and return the body of the redirect response
            return
        }
        (target as? URLSessionTaskDelegate)?.urlSession?(session, task: task, willPerformHTTPRedirection: response, newRequest: request, completionHandler: completionHandler)
    }
    
    @available(iOS 7.0, *)
    func urlSession(_ session: URLSession, task: URLSessionTask, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Swift.Void) {
        guard target != nil, target!.responds(to: #function) else {
            completionHandler(.performDefaultHandling, nil)
            return
        }
        (target as? URLSessionTaskDelegate)?.urlSession?(session, didReceive: challenge, completionHandler: completionHandler)
    }
    
    @available(iOS 7.0, *)
    func urlSession(_ session: URLSession, task: URLSessionTask, needNewBodyStream completionHandler: @escaping (InputStream?) -> Swift.Void) {
        guard target != nil, target!.responds(to: #function) else {
            completionHandler(nil)
            return
        }
        (target as? URLSessionTaskDelegate)?.urlSession?(session, task: task, needNewBodyStream: completionHandler)
    }
    
    @available(iOS 7.0, *)
    func urlSession(_ session: URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
        (target as? URLSessionTaskDelegate)?.urlSession?(session, task: task, didSendBodyData: bytesSent, totalBytesSent: totalBytesSent, totalBytesExpectedToSend: totalBytesExpectedToSend)
    }
    
    @available(iOS 10.0, *)
    func urlSession(_ session: URLSession, task: URLSessionTask, didFinishCollecting metrics: URLSessionTaskMetrics) {
        (target as? URLSessionTaskDelegate)?.urlSession?(session, task: task, didFinishCollecting: metrics)
    }
    
    @available(iOS 7.0, *)
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        (target as? URLSessionTaskDelegate)?.urlSession?(session, task: task, didCompleteWithError: error)
    }
    */
    
}

extension URLSessionDelegateProxy: URLSessionDataDelegate {
    
    /*
    @available(iOS 7.0, *)
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Swift.Void) {
        guard target != nil, target!.responds(to: #function) else {
            completionHandler(.allow)
            return
        }
        (target as? URLSessionDataDelegate)?.urlSession?(session, dataTask: dataTask, didReceive: response, completionHandler: completionHandler)
    }
    
    @available(iOS 7.0, *)
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didBecome downloadTask: URLSessionDownloadTask) {
        (target as? URLSessionDataDelegate)?.urlSession?(session, dataTask: dataTask, didBecome: downloadTask)
    }
    
    @available(iOS 9.0, *)
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didBecome streamTask: URLSessionStreamTask) {
        (target as? URLSessionDataDelegate)?.urlSession?(session, dataTask: dataTask, didBecome: streamTask)
    }
    
    @available(iOS 7.0, *)
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        (target as? URLSessionDataDelegate)?.urlSession?(session, dataTask: dataTask, didReceive: data)
    }
    
    @available(iOS 7.0, *)
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, willCacheResponse proposedResponse: CachedURLResponse, completionHandler: @escaping (CachedURLResponse?) -> Swift.Void) {
        guard target != nil, target!.responds(to: #function) else {
            completionHandler(proposedResponse)
            //completionHandler(nil) // prevent caching
            return
        }
        (target as? URLSessionDataDelegate)?.urlSession?(session, dataTask: dataTask, willCacheResponse: proposedResponse, completionHandler: completionHandler)
    }
    */
    
}

extension URLSessionDelegateProxy: URLSessionDownloadDelegate {
    
    // REQUIRED
    @available(iOS 7.0, *)
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        (target as? URLSessionDownloadDelegate)?.urlSession(session, downloadTask: downloadTask, didFinishDownloadingTo: location)
    }
    
    /*
    @available(iOS 7.0, *)
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        (target as? URLSessionDownloadDelegate)?.urlSession?(session, downloadTask: downloadTask, didWriteData: bytesWritten, totalBytesWritten: totalBytesWritten, totalBytesExpectedToWrite: totalBytesExpectedToWrite)
    }
    
    @available(iOS 7.0, *)
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didResumeAtOffset fileOffset: Int64, expectedTotalBytes: Int64) {
        (target as? URLSessionDownloadDelegate)?.urlSession?(session, downloadTask: downloadTask, didResumeAtOffset: fileOffset, expectedTotalBytes: expectedTotalBytes)
    }
    */
    
}

extension URLSessionDelegateProxy: URLSessionStreamDelegate {
    
    /*
    @available(iOS 9.0, *)
    func urlSession(_ session: URLSession, readClosedFor streamTask: URLSessionStreamTask) {
        (target as? URLSessionStreamDelegate)?.urlSession?(session, readClosedFor: streamTask)
    }
    
    @available(iOS 9.0, *)
    func urlSession(_ session: URLSession, writeClosedFor streamTask: URLSessionStreamTask) {
        (target as? URLSessionStreamDelegate)?.urlSession?(session, writeClosedFor: streamTask)
    }
    
    @available(iOS 9.0, *)
    func urlSession(_ session: URLSession, betterRouteDiscoveredFor streamTask: URLSessionStreamTask) {
        (target as? URLSessionStreamDelegate)?.urlSession?(session, betterRouteDiscoveredFor: streamTask)
    }
    
    @available(iOS 9.0, *)
    func urlSession(_ session: URLSession, streamTask: URLSessionStreamTask, didBecome inputStream: InputStream, outputStream: OutputStream) {
        (target as? URLSessionStreamDelegate)?.urlSession?(session, streamTask: streamTask, didBecome: inputStream, outputStream: outputStream)
    }
    */
    
}
