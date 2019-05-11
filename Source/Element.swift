//
//  Element.swift
//  JavaScriptCoreBrowserObjectModel
//
//  Created by Connor Grady on 5/6/19.
//  Copyright © 2019 Connor Grady. All rights reserved.
//

import Foundation
import JavaScriptCore

/*
// SPEC: https://developer.mozilla.org/en-US/docs/Web/API/Node
@objc public protocol ElementJSProtocol: JSExport, NodeJSProtocol {
    var attributes: JSValue { get }
    var classList: [String] { get }
    var className: String { get set }
    var clientHeight: Float { get }
    var clientLeft: Float { get }
    var clientTop: Float { get }
    var clientWidth: Float { get }
    var computedName: String { get }
    var computedRole: String { get }
    var id: String { get set }
    var innerHTML: String { get set }
    var localName: String { get }
    var namespaceURI: String? { get }
    var nextElementSibling: Element? { get }
    var outerHTML: String { get set }
    var prefix: String? { get }
    var previousElementSibling: Element? { get }
    var scrollHeight: Float { get }
    var scrollLeft: Float { get set }
    var scrollTop: Float { get set }
    var scrollWidth: Float { get }
    //var shadowRoot: ShadowRoot? { get }
    var tagName: String { get }
    //func attachShadow(_ shadowRoot: ShadowRoot) -> ShadowRoot
    func getAttribute(_ attributeName: String) -> String?
    func getAttributeNames() -> [String]
    func getAttributeNS(_ namespace: String, _ name: String) -> String?
    func getBoundingClientRect() -> JSValue/*DOMRect*/
    func getClientRects() -> [JSValue/*DOMRect*/]
    func getElementsByClassName(_ names: String) -> [Element]
    func getElementsByTagName(_ tagName: String) -> [Element]
    func getElementsByTagNameNS(_ namespaceURI: String, _ localName: String) -> [Element]
    func hasAttribute(_ name: String) -> Bool
    func hasAttributeNS(_ namespace: String, _ localName: String) -> Bool
    func hasAttributes() -> Bool
    func hasPointerCapture(_ pointerId: String) -> Bool
    func insertAdjacentElement(_ positio: String, _ element: Element) -> Element?
    func insertAdjacentHTML(_ position: String, _ text: String) -> Element?
    
//    func appendChild(_ child: Node) -> Node
//    func cloneNode(_ deep: Bool) -> Node
//    func compareDocumentPosition(_ otherNode: Node) -> UInt8
//    func contains(_ otherNode: Node) -> Bool
//    func getRootNode(_ options: JSValue?) -> Node
//    func hasChildNodes() -> Bool
//    func insertBefore(_ newNode: Node, _ referenceNode: Node?) -> Node
//    func isDefaultNamespace(_ namespaceURI: String?) -> Bool
//    func isEqualNode(_ otherNode: Node) -> Bool
//    func isSameNode(_ otherNode: Node) -> Bool
//    func lookupPrefix() -> String?
//    func lookupNamespaceURI(_ prefix: String?) -> String?
//    func normalize() -> Void
//    func removeChild(_ child: Node) -> Node
//    func replaceChild(_ newChild: Node, _ oldChild: Node) -> Node
}

@objc public class Element: Node, ElementJSProtocol {
    
}
*/
