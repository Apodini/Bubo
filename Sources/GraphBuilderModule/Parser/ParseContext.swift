//
//  ParserContext.swift
//  Bubo
//
//  Created by Valentin Hartig on 27/05/20
//  Copyright © 2020 TUM LS1. All rights reserved.
//


import Foundation
import SwiftSyntax


// MARK: ParseContext
/// Represents the context of what AST of format `SourceFileSyntax` belongs to which file
public struct ParseContext {
    
    /// The file URL representing the file
    let fileURL: URL

    /// An object that converts `AbsolutePosition` values to `SourceLocation` values.
    let sourceLocationConverter: SourceLocationConverter
    
    init(fileURL: URL, sourceFileSyntax: SourceFileSyntax) {
        self.fileURL = fileURL
        self.sourceLocationConverter = SourceLocationConverter(file: fileURL.path, tree: sourceFileSyntax)
    }
}
