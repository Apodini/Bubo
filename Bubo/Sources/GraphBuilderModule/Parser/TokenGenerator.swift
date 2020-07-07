//
//  Created by Valentin Hartig on 27.05.20.
//

import Foundation
import SwiftSyntax


/// Standard implementaion of a **SwiftSnytax** `SyntaxVisitor`. Please refer to the **SwfitSyntax** documentation
class TokenGenerator: SyntaxVisitor {
    
    var tokens: [Token] = []
    var tokenExtensions: [String:Token] = [:]
    private let parseContext: ParseContext
    
    init(parseContext: ParseContext) {
        self.parseContext = parseContext
    }
    
    override func visit(_ node: ClassDeclSyntax) -> SyntaxVisitorContinueKind {
        if let position = findLocation(syntax: node.identifier) {
                        tokens.append(Token(name: node.identifier.text, tokenKind: .class, location: position))
        }
        return .visitChildren
    }
    
    override func visit(_ node: StructDeclSyntax) -> SyntaxVisitorContinueKind {
        if let position = findLocation(syntax: node.identifier) {
            tokens.append(Token(name: node.identifier.text, tokenKind: .struct, location: position))
        }
        return .visitChildren
    }
    
    override func visit(_ node: FunctionDeclSyntax) -> SyntaxVisitorContinueKind {
//        let parameters = node.signature.input.parameterList.compactMap {
//            $0.firstName?.text
//        }
//         TODO: Pass the right function name to the token -> refere to pecker on how to do it
//         let function = Function(name: node.identifier.text, parameters: parameters)
        
        if let position = findLocation(syntax: node.identifier) {
            tokens.append(Token(name: node.identifier.text, tokenKind: .function, location: position))
        }
        return .visitChildren
    }
    
    override func visit(_ node: EnumDeclSyntax) -> SyntaxVisitorContinueKind {
        if let position = findLocation(syntax: node.identifier) {
            tokens.append(Token(name: node.identifier.text, tokenKind: .enum, location: position))
        }
        return .visitChildren
    }
    
    override func visit(_ node: ProtocolDeclSyntax) -> SyntaxVisitorContinueKind {
        if let position = findLocation(syntax: node.identifier) {
            tokens.append(Token(name: node.identifier.text, tokenKind: .protocol, location: position))
        }
        return .visitChildren
    }
    
    override func visit(_ node: TypealiasDeclSyntax) -> SyntaxVisitorContinueKind {
        if let position = findLocation(syntax: node.identifier) {
            tokens.append(Token(name: node.identifier.text, tokenKind: .typealias, location: position))
        }
        return .visitChildren
    }
    
    override func visit(_ node: OperatorDeclSyntax) -> SyntaxVisitorContinueKind {
        if let position = findLocation(syntax: node.identifier) {
            tokens.append(Token(name: node.identifier.text, tokenKind: .operator, location: position))
        }
        return .visitChildren
    }
    
    override func visit(_ node: ExtensionDeclSyntax) -> SyntaxVisitorContinueKind {
        for token in node.extendedType.tokens {
            if let position = findLocation(syntax: token) {
                let source = Token(name: token.text , tokenKind: .extension, location: position)
                self.tokenExtensions[source.identifier] = source
            }
        }
        return .visitChildren
    }
    
    
    // Add more overrides here if more tokens are needed
}


extension TokenGenerator {
    
    /// Converts a SwiftSyntax location to a token location
    ///
    /// - parameter syntax: A SwiftSyntax token
    /// - returns: A token location if the location could be converted, else nil
    func findLocation(syntax: SyntaxProtocol) -> TokenLocation? {
        let location = parseContext.sourceLocationConverter.location(for: syntax.positionAfterSkippingLeadingTrivia)
        guard let line = location.line,
            let column = location.column else {
            return nil
        }
        return TokenLocation(url: parseContext.fileURL, line: line, column: column, offset: location.offset)
    }
}
