//
//  JSDocumentViewController.swift
//  JS Notepad
//
//  Created by Connor Grady on 1/6/18.
//  Copyright © 2018 Connor Grady. All rights reserved.
//

import UIKit
import JavaScriptCore
import JavaScriptCoreBrowserObjectModel

class JSDocumentViewController: UIViewController {
    
    var document: JSDocument? {
        willSet {
            //document?.removeObserver(self, forKeyPath: "hasUnsavedChanges", context: nil)
            if currentJSContext != nil {
                currentJSContext = nil
            }
        }
        //didSet {
        //    document?.addObserver(self, forKeyPath: "hasUnsavedChanges", options: .new, context: nil)
        //}
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBOutlet weak var consoleTextView: UITextView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    private var isTrackingBottomOfTextView: Bool = true
    
    var currentJSContext: JSContext?
    
    private func createContext() -> JSContext {
        let jsContext = JSContext2()!
        jsContext.exceptionHandler = { [weak consoleTextView] (context, exception) in
            print("jsContext.exceptionHandler()\n\(String(describing: exception))")
            print("  exception.isString: \(exception!.isString)")
            print("  exception.isObject: \(exception!.isObject)")
            print("  exception.isError: \(exception!.isError)")
            if let exception = exception, exception.isObject {
                print("\(exception.toObject())")
            }
            consoleTextView?.text.append("\n[ERROR] \(exception?.debugDescription ?? "nil")\n\n")
        }
        
        // inject `JavaScriptCoreBrowserObjectModel` stuff
        
        // Console
        jsContext.setObject(Console.self, forKeyedSubscript: "Console" as (NSCopying & NSObjectProtocol))
        //let oStream = TextViewOutputStream(textView: consoleTextView)
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "HH:mm:ss.SSS"
        let oStream = TextViewOutputStream(textView: consoleTextView, dateFormatter: dateFormatter)
        let console = Console(stdout: oStream, stderr: oStream)
        jsContext.setObject(console, forKeyedSubscript: "console" as (NSCopying & NSObjectProtocol))
        
        // Timers
        //context.setObject(Timers.self, forKeyedSubscript: "Timers" as (NSCopying & NSObjectProtocol))
        Timers.extend(jsContext)
        
        // XMLHttpRequest
        jsContext.setObject(XMLHttpRequest.self, forKeyedSubscript: "XMLHttpRequest" as (NSCopying & NSObjectProtocol))
        
        // babel-polyfill
        let babelPolyfillUrl = Bundle(for: type(of: self)).url(forResource: "polyfill", withExtension: "js", subdirectory: "js-libs/babel-polyfill")!
        let babelPolyfill = try! String(contentsOf: babelPolyfillUrl)
        jsContext.evaluateScript(babelPolyfill)
        
        // whatwg-fetch
        let fetchPolyfillUrl = Bundle(for: type(of: self)).url(forResource: "fetch", withExtension: "js", subdirectory: "js-libs/whatwg-fetch")!
        let fetchPolyfill = try! String(contentsOf: fetchPolyfillUrl)
        jsContext.evaluateScript(fetchPolyfill)
        
        return jsContext
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        consoleTextView.contentInset.bottom = consoleTextView.font?.lineHeight ?? 8
        consoleTextView.addObserver(self, forKeyPath: "contentSize", options: [ .new, .old ], context: nil)
        
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let object = object as? UITextView, object === consoleTextView, keyPath == "contentSize" {
            if isTrackingBottomOfTextView {
                consoleTextView.scrollToBottom(animated: false)
            }
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("JSDocumentViewController viewWillAppear( animated: \(animated) )")
        super.viewWillAppear(animated)
        
        title = document?.fileURL.lastPathComponent
        
        self.currentJSContext = nil
        consoleTextView.text = ""
        loadingIndicator.startAnimating()
        
        // Access the document
        document?.open(completionHandler: { success in
            if success {
                self.consoleTextView.text = "[INFO] Loaded \(self.document?.fileURL.lastPathComponent ?? "")\n"
            } else {
                // Make sure to handle the failed import appropriately, e.g., by presenting an error message to the user.
                //self.consoleTextView.text = "\n[ERROR] Failed to open \(self.document!.fileURL.path)\n\n"
                self.consoleTextView.text = "\n[ERROR] Failed to open \(self.document?.fileURL.lastPathComponent ?? "nil")\n\n"
            }
            self.loadingIndicator.stopAnimating()
        })
    }
    
    @IBAction func dismissDocumentViewController() {
        dismiss(animated: true) {
            self.document?.close(completionHandler: nil)
            //self.document?.close(completionHandler: { success in
            //    self.document = nil
            //})
            self.currentJSContext = nil
            self.consoleTextView.text = ""
        }
    }
    
    @IBAction func clearConsoleOutput() {
        consoleTextView.text = ""
    }

    @IBAction func executeDocument(_ sender: UIBarButtonItem?) {
        
        let jsContext = createContext()
        currentJSContext = jsContext  // retain context
        
        if consoleTextView.text.count > 0 {
            consoleTextView.text.append("\n\n\n\n")
            // figure out how many lines it takes to fill the visible height of `consoleTextView`
            //let lineHeight = consoleTextView.font?.lineHeight ?? 8
            //let visibleHeight = consoleTextView.visibleContentFrame.height
            //let lineCount = Int(floor(visibleHeight / lineHeight))
            //consoleTextView.text.append(String(repeating: "\n", count: lineCount))
        }
        consoleTextView.text.append("\n[INFO] executing \(document!.fileURL.lastPathComponent) ...\n\n")
        
        //JSCheckScriptSyntax(jsContext.jsGlobalContextRef, JSStringCreateWithCFString(document!.scriptText! as CFString), JSStringCreateWithCFString(document!.localizedName as CFString), 0, nil)
        //let scriptFn = JSObjectMakeFunction(jsContext.jsGlobalContextRef, JSStringCreateWithCFString(document!.localizedName as CFString), 0, nil, JSStringCreateWithCFString(document!.scriptText! as CFString), JSStringCreateWithCFString(document!.localizedName as CFString), 0, nil)!
        //JSObjectCallAsFunction(jsContext.jsGlobalContextRef, scriptFn, jsContext.jsGlobalContextRef, 0, nil, nil)
        
        var mainFn = jsContext.evaluateScript(document!.scriptText!)!
        if !mainFn.isFunction {
            mainFn = jsContext.objectForKeyedSubscript("main")
        }
        if mainFn.isFunction {
            mainFn.callAsync(withArguments: []) { [unowned self, weak jsContext] (result, error) in
                DispatchQueue.main.async {
                    if let error = error/*, error.isError*/ {
                        print("    error: \(error.debugDescription)")
                        print("  error.isString: \(error.isString)")
                        print("  error.isObject: \(error.isObject)")
                        print("  error.isError: \(error.isError)")
                        if error.isError {
                            print("\(error.toObject())")
                            //print("\(String(describing: error.value(forKey: "stack")))")
                            print("\(String(describing: error.forProperty("stack")))")
                        }
                        self.consoleTextView.text.append("\n[ERROR] \(error.debugDescription)\n\n")
                    } else if let result = result, !result.isUndefined, !result.isNull {
                        print("    result: \(String(describing: result))")
                        self.consoleTextView.text.append("\n[INFO] Script returned:\n\(result.debugDescription)\n\n")
                    } else {
                        self.consoleTextView.text.append("\n[INFO] Script finished executing\n\n")
                    }
                    //self.currentJSContext = nil  // release context
                    //JSGlobalContextRelease(jsContext.jsGlobalContextRef)  // release context
                    if jsContext != nil, self.currentJSContext === jsContext {
                        self.currentJSContext = nil  // release context
                    }
                }
            }
        } else {
            consoleTextView.text.append("\n[INFO] Script finished executing\n\n")
            currentJSContext = nil  // release context
        }
        
    }
    
}



extension JSDocumentViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if isTrackingBottomOfTextView {
            textView.scrollToBottom(animated: true)
        }
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isTrackingBottomOfTextView = false
    }
    func scrollViewDidChangeAdjustedContentInset(_ scrollView: UIScrollView) {
        if isTrackingBottomOfTextView {
            scrollView.scrollToBottom(animated: true)
        }
    }
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let adjustedTargetContentOffset = CGPoint(
            x: targetContentOffset.pointee.x + scrollView.adjustedContentInset.left,
            y: targetContentOffset.pointee.y + scrollView.adjustedContentInset.top
        )
        let targetMaxY = adjustedTargetContentOffset.y + scrollView.visibleContentFrame.height
        if targetMaxY >= scrollView.contentSize.height {
            isTrackingBottomOfTextView = true
        }
    }
}



extension UIScrollView {
    var visibleContentFrame: CGRect {
        return UIEdgeInsetsInsetRect(bounds, adjustedContentInset)
    }
    var isScrolledToBottom: Bool {
        return visibleContentFrame.maxY >= contentSize.height
    }
    func scrollToBottom(animated: Bool) {
        //guard !isScrolledToBottom else { return }
        let deltaY = contentSize.height - visibleContentFrame.maxY
        guard deltaY > 0 else { return }
        //let newContentOffset = CGPoint(x: 0, y: contentOffset.y + deltaY)
        let newContentOffset = CGPoint(x: contentOffset.x, y: contentOffset.y + deltaY)
        //setContentOffset(newContentOffset, animated: animated)
        DispatchQueue.main.async { [unowned self] in
            self.setContentOffset(newContentOffset, animated: animated)
        }
    }
}







extension JSValue {
    
    var isFunction: Bool {
        guard isObject else { return false }
        return JSObjectIsFunction(context.jsGlobalContextRef, jsValueRef)
    }
    var isError: Bool {
        guard isObject else { return false }
        let JSError = context.objectForKeyedSubscript("Error")!
        guard JSError.isObject else { return false }
        var jsException: JSValueRef? = nil
        return JSValueIsInstanceOfConstructor(context.jsGlobalContextRef, jsValueRef, JSError.jsValueRef, &jsException)
    }
    var isPromise: Bool {
        guard isObject else { return false }
        let JSPromise = context.objectForKeyedSubscript("Promise")!
        guard JSPromise.isObject else { return false }
        var jsException: JSValueRef? = nil
        return JSValueIsInstanceOfConstructor(context.jsGlobalContextRef, jsValueRef, JSPromise.jsValueRef, &jsException)
        //return forProperty("then").isFunction
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



class JSContext2: JSContext {
    deinit {
        print("JSContext2 deinit")
    }
}
