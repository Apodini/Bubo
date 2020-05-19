//
//  Created by Valentin Hartig on 12.05.20.
//

// import SwiftSyntax
import Foundation
import SwiftSyntax

class Parser {
    
    init() {
    }
    // Parses all files of a service and retruns an array of graphs
    func parse(service: Service) -> Graph {
        var sourceFileSyntaxes = [SourceFileSyntax]()
        for file in service.files {
            if file.fileURL.pathExtension == "swift" {
                do {
                    let sourceFileSyntax = try SyntaxParser.parse(file.fileURL)
                    sourceFileSyntaxes.append(sourceFileSyntax)
                } catch  {
                    warningMessage(msg: "Couldn't parse source file \(file.fileName)")
                }
            }
        }
        return Graph(service: service, sourceFileSyntaxes: sourceFileSyntaxes)
    }
    
}
