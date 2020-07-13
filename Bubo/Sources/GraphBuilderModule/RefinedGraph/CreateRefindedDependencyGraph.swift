//
//  Created by Valentin Hartig on 07.07.20.
//

import Foundation


extension GraphBuilder {
    public func generateRefinedDependencyGraph() -> Void {
        
        if let rawGraph: RawDependencyGraph<Node> = self.generateRawDependencyGraph() {
            let refinedGraph: RefinedDependencyGraph<Node> = RefinedDependencyGraph<Node>()
            
            /// Copy the raw graph
            for v in rawGraph.vertices {
                refinedGraph.addVertex(v)
            }
            
            for edge in rawGraph.edgeList() {
                refinedGraph.addEdge(from: rawGraph.vertexAtIndex(edge.u), to: rawGraph.vertexAtIndex(edge.v), directed: true, role: edge.roles)
            }
            
            /// Create the groups
            
            let rawGraphClustered: [RawDependencyGraph<Node>] = clusterByClasses(originalGraph: rawGraph)

            for cluster in rawGraphClustered {
                let groupID = refinedGraph.addGroup(group: cluster)
                for node in cluster.vertices {
                    if let index = refinedGraph.indexOfVertex(node) {
                        node.groupID = groupID
                        refinedGraph.vertices[index] = node
                    }
                }
            }
            self.graph = refinedGraph
        } else {
            abortMessage(msg: "Graph refinement")
        }
    }
}
