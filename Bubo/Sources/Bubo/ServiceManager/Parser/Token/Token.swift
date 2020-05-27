//
//  Created by Valentin Hartig on 27.05.20.
//

import Foundation

public struct Token {
    
    public var name: String
    
    public var tokenKind: TokenKind
    
    public var tokenRole: TokenRole?
    
    public var location: TokenLocation
    
    public var relations: [TokenRelation]?
    
    init(name: String, tokenKind: TokenKind, location: TokenLocation) {
        self.name = name
        self.tokenKind = tokenKind
        self.location = location
        self.tokenRole = nil
        self.relations = nil
    }
    
    init(name: String, tokenKind: TokenKind, location: TokenLocation, tokenRole: TokenRole, relations: [TokenRelation]) {
        self.name = name
        self.tokenKind = tokenKind
        self.location = location
        self.tokenRole = tokenRole
        self.relations = relations
    }
}

extension Token: CustomStringConvertible {
    public var description: String {
        "\(name) | \(tokenKind) | \(location.description)"
    }
}

extension Token: Equatable {
    public static func == (lhs: Token, rhs: Token) -> Bool {
        lhs.name == rhs.name && lhs.location == rhs.location
    }
}

extension Token {
    var needFilterExtension: Bool {
        return tokenKind == .class ||
            tokenKind == .struct ||
            tokenKind == .enum ||
            tokenKind == .protocol
    }
}

extension Token {
    var identifier: String {
        return "\(location.url.path):\(location.line):\(location.column)"
    }
}
