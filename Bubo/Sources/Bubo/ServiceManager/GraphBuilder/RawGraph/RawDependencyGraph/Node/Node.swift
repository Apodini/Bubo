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
    
    /// The roles of the node e.g. a definition, declaration etc.
    var roles: [NodeRole]
    
    var groupID: Int?
    
    var location: NodeLocation
    
    /// Make the node conform to the `CustomStringConvertible` protocol
    public var description: String {
        var rolesString: String = ""
        for role in roles {
            rolesString.append(" \(role) |")
        }
        return "\(name) | \(kind) | GroupID: \(groupID ?? -1)\n[\(rolesString.dropLast())]\n\(location)\n\(usr)"
    }
    
    /// The standard constructor
    init(usr: String, kind: NodeKind, name: String, roles: [NodeRole], location: NodeLocation) {
        self.usr = usr
        self.kind = kind
        self.name = name
        self.roles = roles
        self.groupID = nil
        self.location = location
    }
    
    /// A constructor that creates a node based on a IndexStoreDB Symbol
    init(symbol: Symbol, roles: SymbolRole, location: SymbolLocation) {
        self.usr = symbol.usr
        self.kind = Node.getNodeKind(symbol: symbol)
        self.name = symbol.name
        self.roles = NodeRole.getNodeRoles(symbolRole: roles)
        self.groupID = nil
        self.location = NodeLocation(loc: location)
    }
    
    /// The  constructor for refined graphs
    init(usr: String, kind: NodeKind, name: String, roles: [NodeRole], groupID: Int, location: NodeLocation) {
        self.usr = usr
        self.kind = kind
        self.name = name
        self.roles = roles
        self.groupID = groupID
        self.location = location
    }
    
    /// Make the node conform to the `Equatable` protocol to be accepted as a node in a **SwiftGraph** graph
    public static func == (lhs: Node, rhs: Node) -> Bool {
        var compareRoles: Bool = true
        
        if lhs.roles.count == rhs.roles.count {
            for role in rhs.roles {
                if !lhs.roles.contains(role) {
                    compareRoles = false
                    break
                }
            }
        } else {
            compareRoles = false
        }
        
        return lhs.usr == rhs.usr && lhs.kind == rhs.kind && lhs.name == rhs.name && compareRoles
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
