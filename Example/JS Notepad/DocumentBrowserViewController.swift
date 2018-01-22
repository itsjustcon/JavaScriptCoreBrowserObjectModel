//
//  DocumentBrowserViewController.swift
//  JS Notepad
//
//  Created by Connor Grady on 1/6/18.
//  Copyright © 2018 Connor Grady. All rights reserved.
//

import UIKit


class DocumentBrowserViewController: UIDocumentBrowserViewController, UIDocumentBrowserViewControllerDelegate {
    
    //override var allowedContentTypes: [String] {
    //    return ["com.netscape.javascript-​source"]
    //    //return [Document().fileType]
    //}
    
    /*
    override init(forOpeningFilesWithContentTypes allowedContentTypes: [String]?) {
        print("DocumentBrowserViewController init( forOpeningFilesWithContentTypes: \(String(describing: allowedContentTypes)) )")
        super.init(forOpeningFilesWithContentTypes: allowedContentTypes)
    }
    required init?(coder aDecoder: NSCoder) {
        print("DocumentBrowserViewController init?( coder: NSCoder )")
        super.init(coder: aDecoder)
        print("  allowedContentTypes: \(allowedContentTypes)")
    }
    */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self
        
        allowsDocumentCreation = true
        allowsPickingMultipleItems = false
        
        // Update the style of the UIDocumentBrowserViewController
        browserUserInterfaceStyle = .dark
        view.tintColor = .white
        
        // Specify the allowed content types of your application via the Info.plist.
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    // MARK: UIDocumentBrowserViewControllerDelegate
    
    func documentBrowser(_ controller: UIDocumentBrowserViewController, didRequestDocumentCreationWithHandler importHandler: @escaping (URL?, UIDocumentBrowserViewController.ImportMode) -> Void) {
        print("DocumentBrowserViewController documentBrowser( controller: UIDocumentBrowserViewController, didRequestDocumentCreationWithHandler: @escaping (URL?, UIDocumentBrowserViewController.ImportMode ) )")
        
        /*
        let newDocumentURL: URL? = nil
        
        // Set the URL for the new document here. Optionally, you can present a template chooser before calling the importHandler.
        // Make sure the importHandler is always called, even if the user cancels the creation request.
        if newDocumentURL != nil {
            importHandler(newDocumentURL, .move)
        } else {
            importHandler(nil, .none)
        }
        */
        
        // Get a temporary URL...
        //let documentDirectory = FileManager.default.temporaryDirectory
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        //let documentDirectory = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        let url = documentDirectory.absoluteURL.appendingPathComponent("\(UUID().uuidString).js", isDirectory: false)
        print("  url: \(url)")
        let doc = JSDocument(fileURL: url)
        
        /*
        // Create a new document in a temporary location
        doc.save(to: url, for: .forCreating) { (saveSuccess) in
            
            // Make sure the document saved successfully
            guard saveSuccess else {
                // Cancel document creation
                importHandler(nil, .none)
                return
            }
            
            // Close the document.
            doc.close(completionHandler: { (closeSuccess) in
                
                // Make sure the document closed successfully
                guard closeSuccess else {
                    // Cancel document creation
                    importHandler(nil, .none)
                    return
                }
                
                // Pass the document's temporary URL to the import handler.
                importHandler(url, .move)
            })
        }
        */
        FileManager.default.createFile(atPath: url.path, contents: nil, attributes: [:])
        //doc.save(to: url, for: .forCreating, completionHandler: { success in
        //    if success {
        //        importHandler(url, .move)
        //    } else {
        //        importHandler(nil, .none)
        //    }
        //})
        doc.save(to: url, for: .forCreating) { (saveSuccess) in
            
            // Make sure the document saved successfully
            guard saveSuccess else {
                // Cancel document creation
                importHandler(nil, .none)
                return
            }
            
            // Close the document.
            doc.close(completionHandler: { (closeSuccess) in
                
                // Make sure the document closed successfully
                guard closeSuccess else {
                    // Cancel document creation
                    importHandler(nil, .none)
                    return
                }
                
                // Pass the document's temporary URL to the import handler.
                importHandler(url, .move)
            })
        }
        /*
        // `Untitled-X.js` support
        var idx = 0
        var fileurl = documentDirectory.absoluteURL.appendingPathComponent("Untitled.js", isDirectory: false)
        print("  fileurl: \(fileurl)")
        while FileManager.default.fileExists(atPath: fileurl.path) {
            idx = idx + 1
            fileurl = fileurl.deletingLastPathComponent().appendingPathComponent("Untitled-\(idx).js", isDirectory: false)
            print("  fileurl: \(fileurl)")
        }
        FileManager.default.createFile(atPath: fileurl.path, contents: nil, attributes: nil)
        doc.save(to: fileurl, for: .forCreating, completionHandler: { success in
            if success {
                importHandler(fileurl, .move)
            } else {
                importHandler(nil, .none)
            }
        })
        */
        
    }
    
    func documentBrowser(_ controller: UIDocumentBrowserViewController, didPickDocumentURLs documentURLs: [URL]) {
        print("DocumentBrowserViewController documentBrowser( controller: UIDocumentBrowserViewController, didPickDocumentURLs: \(documentURLs) )")
        guard let sourceURL = documentURLs.first else { return }
        
        // Present the Document View Controller for the first document that was picked.
        // If you support picking multiple items, make sure you handle them all.
        presentDocument(at: sourceURL)
    }
    
    func documentBrowser(_ controller: UIDocumentBrowserViewController, didImportDocumentAt sourceURL: URL, toDestinationURL destinationURL: URL) {
        print("DocumentBrowserViewController documentBrowser( controller: UIDocumentBrowserViewController, didImportDocumentAt: \(sourceURL), toDestinationURL: \(destinationURL) )")
        // Present the Document View Controller for the new newly created document
        presentDocument(at: destinationURL)
    }
    
    func documentBrowser(_ controller: UIDocumentBrowserViewController, failedToImportDocumentAt documentURL: URL, error: Error?) {
        print("DocumentBrowserViewController documentBrowser( controller: UIDocumentBrowserViewController, failedToImportDocumentAt: \(documentURL), error: \(String(describing: error)) )")
        // Make sure to handle the failed import appropriately, e.g., by presenting an error message to the user.
    }
    
    // MARK: Document Presentation
    
    func presentDocument(at documentURL: URL) {
        print("DocumentBrowserViewController presentDocument( at: \(documentURL) )")
        
        //let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        //let documentViewController = storyBoard.instantiateViewController(withIdentifier: "DocumentViewController") as! DocumentViewController
        //documentViewController.document = Document(fileURL: documentURL)
        //present(documentViewController, animated: true, completion: nil)
        
        //let navigationController = UINavigationController(rootViewController: documentViewController)
        let navigationController = storyboard!.instantiateViewController(withIdentifier: "DocumentNavigationController") as! UINavigationController
        let documentViewController = navigationController.viewControllers.first as! JSDocumentViewController
        documentViewController.document = JSDocument(fileURL: documentURL)
        present(navigationController, animated: true, completion: nil)
        
        //performSegue(withIdentifier: "showDocument", sender: self)
        
    }
}

