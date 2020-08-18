//
//  NodeKind.swift
//  Bubo
//
//  Created by Valentin Hartig on 01/06/20
//  Copyright © 2020 TUM LS1. All rights reserved.
//

import Foundation
import IndexStoreDB


// MARK: NodeKind
/// An enum that represents the different types of nodes that can exists in the dependency graph.
/// These kinds are based on the indexStoreDB SymbolKinds
public enum NodeKind {
    case unknown
    case module
    case namespace
    case namespaceAlias
    case macro
    case `enum`
    case `struct`
    case `class`
    case `protocol`
    case `extension`
    case union
    case `typealias`
    case function
    case variable
    case field
    case enumConstant
    case instanceMethod
    case classMethod
    case staticMethod
    case instanceProperty
    case classProperty
    case staticProperty
    case constructor
    case destructor
    case conversionFunction
    case parameter
    case using
    case commentTag
}


/// Make the `NodeKind` enum conform to the `Codable` protocol
extension NodeKind: Codable {
    
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
            self = .unknown
        case 1:
            self = .module
        case 2:
            self = .namespace
        case 3:
            self = .namespaceAlias
        case 4:
            self = .macro
        case 5:
            self = .enum
        case 6:
            self = .struct
        case 7:
            self = .class
        case 8:
            self = .protocol
        case 9:
            self = .extension
        case 10:
            self = .union
        case 11:
            self = .typealias
        case 12:
            self = .function
        case 13:
            self = .variable
        case 14:
            self = .field
        case 15:
            self = .enumConstant
        case 16:
            self = .instanceMethod
        case 17:
            self = .classMethod
        case 18:
            self = .staticMethod
        case 19:
            self = .instanceProperty
        case 20:
            self = .classProperty
        case 21:
            self = .staticProperty
        case 22:
            self = .constructor
        case 23:
            self = .destructor
        case 24:
            self = .conversionFunction
        case 25:
            self = .parameter
        case 26:
            self = .using
        case 27:
            self = .commentTag
        default:
            throw CodingError.unknownValue
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Key.self)
        switch self {
        case .unknown:
            try container.encode(0, forKey: .rawValue)
            
        case .module:
            try container.encode(1, forKey: .rawValue)
            
        case .namespace:
            try container.encode(2, forKey: .rawValue)
            
        case .namespaceAlias:
            try container.encode(3, forKey: .rawValue)
            
        case .macro:
            try container.encode(4, forKey: .rawValue)
            
        case .enum:
            try container.encode(5, forKey: .rawValue)
            
        case .struct:
            try container.encode(6, forKey: .rawValue)
            
        case .class:
            try container.encode(7, forKey: .rawValue)
            
        case .protocol:
            try container.encode(8, forKey: .rawValue)
        
        case .extension:
            try container.encode(9, forKey: .rawValue)
        
        case .union:
            try container.encode(10, forKey: .rawValue)
        
        case .typealias:
            try container.encode(11, forKey: .rawValue)
        
        case .function:
            try container.encode(12, forKey: .rawValue)
        
        case .variable:
            try container.encode(13, forKey: .rawValue)
        
        case .field:
            try container.encode(14, forKey: .rawValue)
        
        case .enumConstant:
            try container.encode(15, forKey: .rawValue)
        
        case .instanceMethod:
            try container.encode(16, forKey: .rawValue)
        
        case .classMethod:
            try container.encode(17, forKey: .rawValue)
        
        case .staticMethod:
            try container.encode(18, forKey: .rawValue)
        
        case .instanceProperty:
            try container.encode(19, forKey: .rawValue)
        
        case .classProperty:
            try container.encode(20, forKey: .rawValue)
        
        case .staticProperty:
            try container.encode(21, forKey: .rawValue)
        
        case .constructor:
            try container.encode(22, forKey: .rawValue)
        
        case .destructor:
            try container.encode(23, forKey: .rawValue)
        
        case .conversionFunction:
            try container.encode(24, forKey: .rawValue)
        
        case .parameter:
            try container.encode(25, forKey: .rawValue)
        
        case .using:
            try container.encode(26, forKey: .rawValue)
        
        case .commentTag:
            try container.encode(27, forKey: .rawValue)
        }
    }
}
