//
//  NodeRoles.swift
//  Bubo
//
//  Created by Valentin Hartig on 23/06/20
//  Copyright © 2020 TUM LS1. All rights reserved.
//


import Foundation
import IndexStoreDB


// MARK: NodeRole: CaseIterable
/// `NodeRole` converts the `indexStoreDB`'s type `SymbolRole` into codeable enum roles to annotate the dependency graphs nodes
public enum NodeRole: CaseIterable {
    // MARK: Primary roles, from indexstore
    case `declaration`
    case `definition`
    case `reference`
    case `read`
    case `write`
    case `call`
    case `dynamic`
    case `addressOf`
    case `implicit`
    
    case `all`
    case unknow
}

// MARK: NodeRole: Codable
/// Make the `NodeRole` enum conform to the `Codable` protocol
extension NodeRole: Codable {
    
    enum Key: CodingKey {
        case rawValue
    }
    
    enum CodingError: Error {
        case unknownValue
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Key.self)
        let rawValue = try container.decode(Int.self, forKey: .rawValue)
        switch rawValue {
        case 0:
            self = .declaration
        case 1:
            self = .definition
        case 2:
            self = .reference
        case 3:
            self = .read
        case 4:
            self = .write
        case 5:
            self = .call
        case 6:
            self = .dynamic
        case 7:
            self = .addressOf
        case 8:
            self = .implicit
        case 9:
            self = .all
        case 10:
            self = .unknow
        default:
            throw CodingError.unknownValue
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Key.self)
        switch self {
        case .declaration:
            try container.encode(0, forKey: .rawValue)
            
        case .definition:
            try container.encode(1, forKey: .rawValue)
            
        case .reference:
            try container.encode(2, forKey: .rawValue)
            
        case .read:
            try container.encode(3, forKey: .rawValue)
            
        case .write:
            try container.encode(4, forKey: .rawValue)
            
        case .call:
            try container.encode(5, forKey: .rawValue)
            
        case .dynamic:
            try container.encode(6, forKey: .rawValue)
            
        case .addressOf:
            try container.encode(7, forKey: .rawValue)
            
        case .implicit:
            try container.encode(8, forKey: .rawValue)
        
        case .all:
            try container.encode(9, forKey: .rawValue)
        
        case .unknow:
            try container.encode(10, forKey: .rawValue)
        }
    }
}


// MARK: NodeRole
extension NodeRole {
    
    /// Convert a `indexStoreDB` `SymbolRole` into an array of `NodeRoles`
    ///
    /// - parameter symbolRole: The indexStoreDB SymbolRole that should be converte
    /// - returns: An array of NodeRoles that represent the SymbolRole
    
    public static func getNodeRoles(symbolRole: SymbolRole) -> [NodeRole] {
        var edgeRoles: [NodeRole] = [NodeRole]()
        if symbolRole.contains(.declaration) {
            edgeRoles.append(.declaration)
        }
        if symbolRole.contains(.definition) {
            edgeRoles.append(.definition)
        }
        if symbolRole.contains(.reference) {
            edgeRoles.append(.reference)
        }
        if symbolRole.contains(.read) {
            edgeRoles.append(.read)
        }
        if symbolRole.contains(.write) {
            edgeRoles.append(.write)
        }
        if symbolRole.contains(.call) {
            edgeRoles.append(.call)
        }
        if symbolRole.contains(.`dynamic`) {
            edgeRoles.append(.`dynamic`)
        }
        if symbolRole.contains(.addressOf) {
            edgeRoles.append(.addressOf)
        }
        if symbolRole.contains(.implicit) {
            edgeRoles.append(.implicit)
        }
        return edgeRoles
    }
    
    
    /// Convert an EdgeRole into a Symbol Role
    ///
    /// - parameter edgeRole: The EdgeRole that should be converted
    /// - returns: An optional of type `SymbolRole`. Is nil if the EdgeRole is unkown, else returns a simple SymbolRole
    ///
    /// - note: Not sure if this is how it should work --> Could calculate all possible permutations of roles and generate list of SymbolRoles out of it.
    public static func getSymbolRole(nodeRole: NodeRole) -> SymbolRole? {
        switch nodeRole {
        case .declaration:
            return SymbolRole.declaration
        case .definition:
            return SymbolRole.definition
        case .reference:
            return SymbolRole.reference
        case .read:
            return SymbolRole.read
        case .write:
            return SymbolRole.write
        case .call:
            return SymbolRole.call
        case .dynamic:
            return SymbolRole.dynamic
        case .addressOf:
            return SymbolRole.addressOf
        case .implicit:
            return SymbolRole .implicit
        case .all:
            return SymbolRole.all
        default:
            return nil
        }
    }
    
}
