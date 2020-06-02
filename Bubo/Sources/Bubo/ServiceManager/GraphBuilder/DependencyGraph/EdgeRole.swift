//
//  File.swift
//  
//
//  Created by Valentin Hartig on 01.06.20.
//

import Foundation
import IndexStoreDB


public enum EdgeRole {
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
    case unknow
}

extension EdgeRole: Codable {
    
    enum Key: CodingKey {
        case rawValue
    }
    
    enum CodingError: Error {
        case unknownValue
    }
    
    init(symbolRole: SymbolRole) {
        switch symbolRole {
        case .declaration:
            self = .declaration
        case .definition:
            self = .definition
        case .reference:
            self = .reference
        case .read:
            self = .read
        case .write:
            self = .write
        case .call:
            self = .call
        case .dynamic:
            self = .dynamic
        case .addressOf:
            self = .addressOf
        case .implicit:
            self = .implicit
        case .childOf:
            self = .childOf
        case .baseOf:
            self = .baseOf
        case .overrideOf:
            self = .overrideOf
        case .receivedBy:
            self = .receivedBy
        case .calledBy:
            self = .calledBy
        case .extendedBy:
            self = .extendedBy
        case .accessorOf:
            self = .accessorOf
        case .containedBy:
            self = .containedBy
        case .ibTypeOf:
            self = .ibTypeOf
        default:
            self = .unknow
        }
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
            self = .childOf
        case 10:
            self = .baseOf
        case 11:
            self = .overrideOf
        case 12:
            self = .receivedBy
        case 13:
            self = .calledBy
        case 14:
            self = .extendedBy
        case 15:
            self = .accessorOf
        case 16:
            self = .containedBy
        case 17:
            self = .ibTypeOf
        case 18:
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

        case .childOf:
            try container.encode(9, forKey: .rawValue)

        case .baseOf:
            try container.encode(10, forKey: .rawValue)

        case .overrideOf:
            try container.encode(11, forKey: .rawValue)

        case .receivedBy:
            try container.encode(12, forKey: .rawValue)

        case .calledBy:
            try container.encode(13, forKey: .rawValue)

        case .extendedBy:
            try container.encode(14, forKey: .rawValue)

        case .accessorOf:
            try container.encode(15, forKey: .rawValue)

        case .containedBy:
            try container.encode(16, forKey: .rawValue)

        case .ibTypeOf:
            try container.encode(17, forKey: .rawValue)
        
        case .unknow:
            try container.encode(18, forKey: .rawValue)
        }
    }
}
