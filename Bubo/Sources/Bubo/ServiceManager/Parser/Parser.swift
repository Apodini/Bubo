//
//  Created by Valentin Hartig on 12.05.20.
//

// import SwiftSyntax
import Foundation
import SwiftSyntax


class Parser {
    var tokenExtensions: [String: Token] = [:]
    public private(set) var tokens: [Token] = []
    
    init() {
    }
    // Parses all files of a service and retruns an array of graphs
    func parse(service: Service) -> Void {
        var sourceFileSyntaxes = [SourceFileSyntax]()
        for file in service.files {
            if file.fileURL.pathExtension == "swift" {
                outputMessage(msg: "Parsing file \(file.fileName)")
                do {
                    let sourceFileSyntax = try SyntaxParser.parse(file.fileURL)
                    let parseContext = ParseContext(fileURL: file.fileURL, sourceFileSyntax: sourceFileSyntax)
                    let tokenGenerator: TokenGenerator = TokenGenerator(parseContext: parseContext)
                    tokenGenerator.walk(sourceFileSyntax)
                    tokens.append(contentsOf: tokenGenerator.tokens)
                    tokenExtensions.merge(tokenGenerator.tokenExtensions){ (current, _) in current }
                } catch  {
                    warningMessage(msg: "Couldn't parse source file \(file.fileName)")
                }
            }
        }
    }
}
