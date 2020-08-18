//
//  TokenLocation.swift
//  Bubo
//
//  Created by Valentin Hartig on 27/05/20
//  Copyright © 2020 TUM LS1. All rights reserved.
//


import Foundation
import SwiftSyntax

// MARK: TokenLocation: Codable
/// Describes the location of a source token
public struct TokenLocation: Codable {
    
    /// The url of the file the token is in
    public let url: URL
    
    /// The line in the file
    public let line: Int
    
    /// The utf8 column
    public let column: Int
    
    /// The offset
    public let offset: Int
}

// MARK: TokenLocation: CustomStringConvertible
/// Make the location conform to the `CustomStringConvertible` protocol
extension TokenLocation: CustomStringConvertible {
    public var description: String {
        "\(url.path):\(line):\(column)"
    }
}

// MARK: TokenLocation: Equatable
/// Make the location conform to the `Equatable` protocol
extension TokenLocation: Equatable {
    public static func == (lhs: TokenLocation, rhs: TokenLocation) -> Bool {
        lhs.url.path == rhs.url.path && lhs.line == rhs.line && lhs.column == rhs.column
    }
}

// MARK: TokenLocation to SwiftSyntax.SourceLocation
/// Converts a `SourceLocation` to a `SwiftSyntax.SourceLocation`.
extension TokenLocation {
    public var toSwiftSyntaxLocation: SwiftSyntax.SourceLocation {
        return SwiftSyntax.SourceLocation(
            line: line,
            column: column,
            offset: offset,
            file: url.path)
    }
}
