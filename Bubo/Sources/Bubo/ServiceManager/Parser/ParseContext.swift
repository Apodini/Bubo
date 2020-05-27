//
//  Created by Valentin Hartig on 27.05.20.
//

import Foundation
import SwiftSyntax

public struct ParseContext {
    
    let fileURL: URL

    // An object that converts `AbsolutePosition` values to `SourceLocation` values.
    let sourceLocationConverter: SourceLocationConverter
    
    init(fileURL: URL, sourceFileSyntax: SourceFileSyntax) {
        self.fileURL = fileURL
        self.sourceLocationConverter = SourceLocationConverter(file: fileURL.path, tree: sourceFileSyntax)
    }
}
