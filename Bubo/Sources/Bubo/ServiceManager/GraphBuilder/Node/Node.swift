//
//  Created by Valentin Hartig on 17.05.20.
//

import Foundation
import IndexStoreDB


/// Represents a node in the raw dependency graph
public class Node: Codable, Equatable, CustomStringConvertible {
    
    /// Each node is uniquely identified via it's USR (Unified Symbol Resolution)
    var usr: String
    
    /// The kind of the node. Refer to the type `NodeKind` to see different possible kinds
    var kind: NodeKind
    
    /// The name of the node e.g. a struct or function name
    var name: String
    
    /// Make the node conform to the `CustomStringConvertible` protocol
    public var description: String {
        return "\(name) | \(kind)\n\(usr)"
    }
    
    /// The standard constructor
    init(usr: String, kind: NodeKind, name: String) {
        self.usr = usr
        self.kind = kind
        self.name = name
    }
    
    /// A constructor that creates a node based on a IndexStoreDB Symbol
    init(symbol: Symbol) {
        self.usr = symbol.usr
        self.kind = Node.getNodeKind(symbol: symbol)
        self.name = symbol.name
    }
    
    /// Make the node conform to the `Equatable` protocol to be accepted as a node in a **SwiftGraph** graph
    public static func == (lhs: Node, rhs: Node) -> Bool {
        return lhs.usr == rhs.usr && lhs.kind == rhs.kind && lhs.name == rhs.name
    }
    
    /// Get the node kind when constructing node based on indexStoreDB Symbol
    ///
    /// - parameter symbol: The indexStoreDB symbol
    /// - returns: A `NodeKind` enum that rrepresents the SymbolKind of the indexStoreDB Symbol in the graph node
    static func getNodeKind(symbol: Symbol) -> NodeKind {
        switch symbol.kind {
        case .unknown:
            return NodeKind.unknown
        case .module:
            return NodeKind.module
        case .namespace:
            return NodeKind.namespace
        case .namespaceAlias:
            return NodeKind.namespaceAlias
        case .macro:
            return NodeKind.macro
        case .enum:
            return NodeKind.enum
        case .struct:
            return NodeKind.struct
        case .class:
            return NodeKind.class
        case .protocol:
            return NodeKind.protocol
        case .extension:
            return NodeKind.extension
        case .union:
            return NodeKind.union
        case .typealias:
            return NodeKind.typealias
        case .function:
            return NodeKind.function
        case .variable:
            return NodeKind.variable
        case .field:
            return NodeKind.field
        case .enumConstant:
            return NodeKind.enumConstant
        case .instanceMethod:
            return NodeKind.instanceMethod
        case .classMethod:
            return NodeKind.classMethod
        case .staticMethod:
            return NodeKind.staticMethod
        case .instanceProperty:
            return NodeKind.instanceProperty
        case .classProperty:
            return NodeKind.classProperty
        case .staticProperty:
            return NodeKind.staticProperty
        case .constructor:
            return NodeKind.constructor
        case .destructor:
            return NodeKind.destructor
        case .conversionFunction:
            return NodeKind.conversionFunction
        case .parameter:
            return NodeKind.parameter
        case .using:
            return NodeKind.using
        case .commentTag:
            return NodeKind.commentTag
        }
    }
}
