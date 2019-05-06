//
//  Node.swift
//  JavaScriptCoreBrowserObjectModel
//
//  Created by Connor Grady on 5/6/19.
//  Copyright © 2019 Connor Grady. All rights reserved.
//

import Foundation
import JavaScriptCore

// SPEC: https://developer.mozilla.org/en-US/docs/Web/API/Node
@objc public protocol NodeJSProtocol: JSExport, EventTargetJSProtocol {
    var baseURI: String? { get }
    var childNodes: [Node] { get }
    var firstChild: Node? { get }
    var isConnected: Bool { get }
    var lastChild: Node? { get }
    var nextSibling: Node? { get }
    var nodeName: String { get }
    var nodeType: UInt8 { get }
    var nodeValue: String? { get set }
    //var ownerDocument: Document? { get }
    var parentNode: Node? { get }
    //var parentElement: Element? { get }
    var previousSibling: Node? { get }
    var textContent: String? { get set }
    func appendChild(_ child: Node) -> Node
    func cloneNode(_ deep: Bool) -> Node
    func compareDocumentPosition(_ otherNode: Node) -> UInt8
    func contains(_ otherNode: Node) -> Bool
    func getRootNode(_ options: JSValue?) -> Node
    func hasChildNodes() -> Bool
    func insertBefore(_ newNode: Node, _ referenceNode: Node?) -> Node
    func isDefaultNamespace(_ namespaceURI: String?) -> Bool
    func isEqualNode(_ otherNode: Node) -> Bool
    func isSameNode(_ otherNode: Node) -> Bool
    func lookupPrefix() -> String?
    func lookupNamespaceURI(_ prefix: String?) -> String?
    func normalize() -> Void
    func removeChild(_ child: Node) -> Node
    func replaceChild(_ newChild: Node, _ oldChild: Node) -> Node
}

@objc public class Node: EventTarget, NodeJSProtocol {
    
    public var baseURI: String?
    public var childNodes: [Node] = []
    public var firstChild: Node?
    public var isConnected: Bool {
        if let parentNode = self.parentNode {
            return parentNode.isConnected
        } else {
            return false
        }
    }
    public var lastChild: Node? {
        return childNodes.last
    }
    public var nextSibling: Node? {
        if let parentNode = self.parentNode {
            let myIndex = parentNode.childNodes.firstIndex(of: self)!
            guard myIndex < parentNode.childNodes.count-1 else { return nil }
            return parentNode.childNodes[myIndex+1]
        } else {
            return nil
        }
    }
    public var nodeName: String = ""
    public var nodeType: UInt8 = 0
    public var nodeValue: String?
    public var parentNode: Node?
    public var previousSibling: Node? {
        if let parentNode = self.parentNode {
            let myIndex = parentNode.childNodes.firstIndex(of: self)!
            guard myIndex > 0 else { return nil }
            return parentNode.childNodes[myIndex-1]
        } else {
            return nil
        }
    }
    public var textContent: String?
    
    public func appendChild(_ child: Node) -> Node {
        childNodes.append(child)
        return child
    }
    
    public func cloneNode(_ deep: Bool) -> Node {
        // TODO: implement function
    }
    
    public func compareDocumentPosition(_ otherNode: Node) -> UInt8 {
        // TODO: implement function
    }
    
    public func contains(_ otherNode: Node) -> Bool {
        return childNodes.contains(otherNode)
    }
    
    public func getRootNode(_ options: JSValue?) -> Node {
        // TODO: implement function
    }
    
    public func hasChildNodes() -> Bool {
        return childNodes.count > 0
    }
    
    public func insertBefore(_ newNode: Node, _ referenceNode: Node?) -> Node {
        // TODO: implement function
    }
    
    public func isDefaultNamespace(_ namespaceURI: String?) -> Bool {
        // TODO: implement function
    }
    
    public func isEqualNode(_ otherNode: Node) -> Bool {
        // TODO: implement function
    }
    
    public func isSameNode(_ otherNode: Node) -> Bool {
        // TODO: implement function
    }
    
    public func lookupPrefix() -> String? {
        return nil
    }
    
    public func lookupNamespaceURI(_ prefix: String?) -> String? {
        // TODO: implement function
    }
    
    public func normalize() {
        // TODO: implement function
    }
    
    public func removeChild(_ child: Node) -> Node {
        if let childIndex = childNodes.firstIndex(of: child) {
            childNodes.remove(at: childIndex)
        }
        // NOTE: if child is actually not a child of this node, this method should throw an exception.
        return child
    }
    
    public func replaceChild(_ newChild: Node, _ oldChild: Node) -> Node {
        if let oldChildIndex = childNodes.firstIndex(of: oldChild) {
            childNodes.remove(at: oldChildIndex)
            childNodes.insert(newChild, at: oldChildIndex)
        }
        // NOTE: if oldChild is actually not a child of this node, this method should throw an exception.
        return oldChild
    }

}
