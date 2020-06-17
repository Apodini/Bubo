//
//  Created by Valentin Hartig on 27.05.20.
//

import Foundation


/// Represents a syntax token parsed with **SwiftSyntax**
public struct Token {
    
    /// The name of the token
    public var name: String
    
    /// The kind of the token (a smaller subset of the actual graph node kinds)
    public var tokenKind: TokenKind
    
    /// The location of the token (url, line, column, offset)
    public var location: TokenLocation
       
    
    /// The constructor to create a normal token
    init(name: String, tokenKind: TokenKind, location: TokenLocation) {
        self.name = name
        self.tokenKind = tokenKind
        self.location = location
    }
}


/// Conform to the `CustomStringConvertible` protocol
extension Token: CustomStringConvertible {
    public var description: String {
        "\(name) | \(tokenKind) | \(location.description)"
    }
}


/// Confrom to the `Equatable` protocol
extension Token: Equatable {
    public static func == (lhs: Token, rhs: Token) -> Bool {
        lhs.name == rhs.name && lhs.location == rhs.location
    }
}


/// A custom identifier for the source token location
extension Token {
    var identifier: String {
        return "\(location.url.path):\(location.line):\(location.column)"
    }
}
