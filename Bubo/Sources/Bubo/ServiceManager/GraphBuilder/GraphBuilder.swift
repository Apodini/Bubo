//
//  Created by Valentin Hartig on 12.05.20.
//

import Foundation
import SwiftGraph
import SwiftSyntax

class GraphBuilder: SyntaxVisitor {
    
    // Th graph that is 
    var graph: UnweightedGraph<Node>
    
    override init() {
        graph = UnweightedGraph()
    }
    
    // Override visit methode for syntaxtrees here to build the graph
}
