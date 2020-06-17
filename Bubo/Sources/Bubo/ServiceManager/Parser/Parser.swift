//
//  Created by Valentin Hartig on 12.05.20.
//

import Foundation
import SwiftSyntax


/// A syntax parser that uses a **SwiftSyntax** `SyntaxVisitor` to craw the AST of a sourcefile and generate relevant tokens
class Parser {
    
    /// A dictionary associating an extension with a class or struct
    var tokenExtensions: [String: Token] = [:]
    
    /// All generated tokens
    public private(set) var tokens: [Token] = []
    
    init() {}
    
    /// Parses all files of a service
    ///
    /// - parameter service: The service that should be parsed
    
    func parse(service: Service) -> Void {
        for file in service.files {
            
            /// Only parse .swift files
            if file.fileURL.pathExtension == "swift" {
                outputMessage(msg: "Parsing file \(file.fileName)")
                do {
                    /// Try to parse the swift source file and generate the parse context
                    let sourceFileSyntax = try SyntaxParser.parse(file.fileURL)
                    let parseContext = ParseContext(fileURL: file.fileURL, sourceFileSyntax: sourceFileSyntax)
                    
                    /// Create the token generator and let it walk over the AST
                    let tokenGenerator: TokenGenerator = TokenGenerator(parseContext: parseContext)
                    tokenGenerator.walk(sourceFileSyntax)
                    
                    /// Save tthe parsed tokens to the token array
                    tokens.append(contentsOf: tokenGenerator.tokens)
                    tokenExtensions.merge(tokenGenerator.tokenExtensions){ (current, _) in current }
                } catch  {
                    warningMessage(msg: "Couldn't parse source file \(file.fileName)")
                }
            }
        }
    }
}
