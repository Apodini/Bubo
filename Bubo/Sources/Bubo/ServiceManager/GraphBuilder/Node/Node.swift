//
//  File.swift
//  
//
//  Created by Valentin Hartig on 17.05.20.
//

import Foundation
import IndexStoreDB

class Node: Codable, Equatable, CustomStringConvertible {
    var usr: String
    var kind: NodeKind
    var name: String
    
    var description: String {
        return "\(name) | \(kind)"
    }
    
    init(usr: String, kind: NodeKind, name: String) {
        self.usr = usr
        self.kind = kind
        self.name = name
    }
    
    init(symbol: Symbol) {
        self.usr = symbol.usr
        self.kind = Node.getNodeKind(symbol: symbol)
        self.name = symbol.name
    }
    
    static func == (lhs: Node, rhs: Node) -> Bool {
        return lhs.usr == rhs.usr
    }
    
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
