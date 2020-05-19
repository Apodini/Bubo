//
//  Created by Valentin Hartig on 17.05.20.
//

import Foundation
import SwiftGraph
import SwiftSyntax


class Graph {
    
    var service: Service
    var graph: UnweightedGraph<Node>
    var sourceFileSyntaxes: [SourceFileSyntax]
    var graphBuilder: GraphBuilder
    
    init(service: Service, sourceFileSyntaxes: [SourceFileSyntax]) {
        self.sourceFileSyntaxes = sourceFileSyntaxes
        self.graphBuilder = GraphBuilder()
        self.service = service
        
        for syntaxTree in self.sourceFileSyntaxes {
            graphBuilder.walk(syntaxTree)
        }
        self.graph = graphBuilder.graph
    }
}
