//
//  Created by Valentin Hartig on 01.06.20.
//

import Foundation
import IndexStoreDB


/// `EdgeRole` converts the `indexStoreDB`'s type `SymbolRole` into codeable enum roles to annotate the dependency graphs edges
public enum EdgeRole: CaseIterable {
   // MARK: Relation roles, from indexstore
    case `childOf`
    case `baseOf`
    case `overrideOf`
    case `receivedBy`
    case `calledBy`
    case `extendedBy`
    case `accessorOf`
    case `containedBy`
    case `ibTypeOf`
    case `specializationOf`
    case `canonical`
    case `all`
    case unknow
}

/// Make the `EdgeRole` enum conform to the `Codable` protocol
extension EdgeRole: Codable {
    
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
            self = .childOf
        case 1:
            self = .baseOf
        case 2:
            self = .overrideOf
        case 3:
            self = .receivedBy
        case 4:
            self = .calledBy
        case 5:
            self = .extendedBy
        case 6:
            self = .accessorOf
        case 7:
            self = .containedBy
        case 8:
            self = .ibTypeOf
        case 9:
            self = .specializationOf
        case 10:
            self = .canonical
        case 11:
            self = .all
        case 12:
            self = .unknow
        default:
            throw CodingError.unknownValue
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Key.self)
        switch self {
        case .childOf:
            try container.encode(0, forKey: .rawValue)
            
        case .baseOf:
            try container.encode(1, forKey: .rawValue)
            
        case .overrideOf:
            try container.encode(2, forKey: .rawValue)
            
        case .receivedBy:
            try container.encode(3, forKey: .rawValue)
            
        case .calledBy:
            try container.encode(4, forKey: .rawValue)
            
        case .extendedBy:
            try container.encode(5, forKey: .rawValue)
            
        case .accessorOf:
            try container.encode(6, forKey: .rawValue)
            
        case .containedBy:
            try container.encode(7, forKey: .rawValue)
            
        case .ibTypeOf:
            try container.encode(8, forKey: .rawValue)
            
        case .specializationOf:
            try container.encode(9, forKey: .rawValue)
        
        case .canonical:
            try container.encode(10, forKey: .rawValue)
        
        case .all:
            try container.encode(11, forKey: .rawValue)
        
        case .unknow:
            try container.encode(12, forKey: .rawValue)
        }
    }
}

extension EdgeRole {
    
    /// Convert a `indexStoreDB` `SymbolRole` into an array of `EdgeRoles`
    ///
    /// - parameter symbolRole: The indexStoreDB SymbolRole that should be converte
    /// - returns: An array of EdgeRoles that represent the SymbolRole
    
    public static func getEdgeRoles(symbolRole: SymbolRole) -> [EdgeRole] {
        var edgeRoles: [EdgeRole] = [EdgeRole]()
        if symbolRole.contains(.childOf) {
            edgeRoles.append(.childOf)
        }
        if symbolRole.contains(.baseOf) {
            edgeRoles.append(.baseOf)
        }
        if symbolRole.contains(.overrideOf) {
            edgeRoles.append(.overrideOf)
        }
        if symbolRole.contains(.receivedBy) {
            edgeRoles.append(.receivedBy)
        }
        if symbolRole.contains(.calledBy) {
            edgeRoles.append(.calledBy)
        }
        if symbolRole.contains(.extendedBy) {
            edgeRoles.append(.extendedBy)
        }
        if symbolRole.contains(.accessorOf) {
            edgeRoles.append(.accessorOf)
        }
        if symbolRole.contains(.containedBy) {
            edgeRoles.append(.containedBy)
        }
        if symbolRole.contains(.ibTypeOf) {
            edgeRoles.append(.ibTypeOf)
        }
        if symbolRole.contains(.specializationOf) {
            edgeRoles.append(.specializationOf)
        }
        if symbolRole.contains(.canonical) {
            edgeRoles.append(.canonical)
        }
        return edgeRoles
    }
    
    /// Convert an EdgeRole into a Symbol Role
    ///
    /// - parameter edgeRole: The EdgeRole that should be converted
    /// - returns: An optional of type `SymbolRole`. Is nil if the EdgeRole is unkown, else returns a simple SymbolRole
    ///
    /// - note: Not sure if this is how it should work --> Could calculate all possible permutations of roles and generate list of SymbolRoles out of it.
    public static func getSymbolRole(edgeRole: EdgeRole) -> SymbolRole? {
        switch edgeRole {
        case .childOf:
            return SymbolRole.childOf
        case .baseOf:
            return SymbolRole.baseOf
        case .overrideOf:
            return SymbolRole.overrideOf
        case .receivedBy:
            return SymbolRole.receivedBy
        case .calledBy:
            return SymbolRole.calledBy
        case .extendedBy:
            return SymbolRole.extendedBy
        case .accessorOf:
            return SymbolRole.accessorOf
        case .containedBy:
            return SymbolRole.containedBy
        case .ibTypeOf:
            return SymbolRole.ibTypeOf
        case .specializationOf:
            return SymbolRole.specializationOf
        case .canonical:
            return SymbolRole.canonical
        case .all:
            return SymbolRole.all
        default:
            return nil
        }
    }
    
}
