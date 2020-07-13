//
//  Created by Valentin Hartig on 12.05.20.
//

import Foundation
import SwiftSyntax

/// A syntax parser that uses a **SwiftSyntax** `SyntaxVisitor` to craw the AST of a sourcefile and generate relevant tokens
public class Parser {
    
    /// A dictionary associating an extension with a class or struct
    public var tokenExtensions: [String: Token] = [:]
    
    /// All generated tokens
    public private(set) var tokens: [Token] = []
    
    public init() {}
    
    /// Parses all files of a service
    ///
    /// - parameter service: The service that should be parsed
    
    public func parse(files: [URL]) -> Void {
        outputMessage(msg: "Parsing files ...")
        for url in files {
            
            /// Only parse .swift files
            if url.pathExtension == "swift" {
                
                do {
                    /// Try to parse the swift source file and generate the parse context
                    let sourceFileSyntax = try SyntaxParser.parse(url)
                    let parseContext = ParseContext(fileURL: url, sourceFileSyntax: sourceFileSyntax)
                    
                    /// Create the token generator and let it walk over the AST
                    let tokenGenerator: TokenGenerator = TokenGenerator(parseContext: parseContext)
                    tokenGenerator.walk(sourceFileSyntax)
                    
                    /// Save tthe parsed tokens to the token array
                    tokens.append(contentsOf: tokenGenerator.tokens)
                    tokenExtensions.merge(tokenGenerator.tokenExtensions){ (current, _) in current }
                } catch  {
                    warningMessage(msg: "Couldn't parse source file at \(url.path)")
                }
            }
        }
    }
}
