//
//  Created by Valentin Hartig on 27.05.20.
//

import Foundation
import SwiftSyntax

public struct TokenLocation: Codable {
    public let url: URL
    public let line: Int
    public let column: Int
    public let offset: Int
}

extension TokenLocation: CustomStringConvertible {
    public var description: String {
        "\(url.path):\(line):\(column)"
    }
}

extension TokenLocation: Equatable {
    public static func == (lhs: TokenLocation, rhs: TokenLocation) -> Bool {
        lhs.url.path == rhs.url.path && lhs.line == rhs.line && lhs.column == rhs.column
    }
}

extension TokenLocation {
    /// Converts a `SourceLocation` to a `SwiftSyntax.SourceLocation`.
    public var toSwiftSyntaxLocation: SwiftSyntax.SourceLocation {
        return SwiftSyntax.SourceLocation(
            line: line,
            column: column,
            offset: offset,
            file: url.path)
    }
}
