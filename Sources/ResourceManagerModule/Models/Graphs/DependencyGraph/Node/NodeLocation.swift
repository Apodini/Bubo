//
//  NodeLocation.swift
//  Bubo
//
//  Created by Valentin Hartig on 07/07/20
//  Copyright © 2020 TUM LS1. All rights reserved.
//


import Foundation
import IndexStoreDB


// MARK: NodeLocation: Codable
/// Describes the location of a node 
public struct NodeLocation: Codable {
    
    /// The url of the file the token is in
    public let url: URL
    
    /// The line in the file
    public let line: Int
    
    /// The utf8 column
    public let utf8Column: Int
    
    init(loc: SymbolLocation) {
        self.url = URL(fileURLWithPath: loc.path)
        self.line = loc.line
        self.utf8Column = loc.utf8Column
    }
}

/// Make the location conform to the `CustomStringConvertible` protocol
extension NodeLocation: CustomStringConvertible {
    public var description: String {
        "\(url.path)\n\(line):\(utf8Column)"
    }
}

/// Make the location conform to the `Equatable` protocol
extension NodeLocation: Equatable {
    public static func == (lhs: NodeLocation, rhs: NodeLocation) -> Bool {
        lhs.url.path == rhs.url.path && lhs.line == rhs.line && lhs.utf8Column == rhs.utf8Column
    }
}
