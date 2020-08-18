//
//  CreateRefindedDependencyGraph.swift
//  Bubo
//
//  Created by Valentin Hartig on 07/07/20
//  Copyright © 2020 TUM LS1. All rights reserved.
//


import Foundation
import ResourceManagerModule


// MARK: GraphBuilder
extension GraphBuilder {
    
    /// Generates  a dependency graph where the nodes have groupIDs identifing related groups of code. These are also stored as their own graphs in a group dictionary to search groups of related code.
    public func generateRefinedDependencyGraph() -> Void {
        
        if let rawGraph: DependencyGraph<Node> = self.generateRawDependencyGraph() {
            let refinedGraph: DependencyGraph<Node> = DependencyGraph<Node>()
            
            /// Copy the raw graph
            for v in rawGraph.vertices {
                refinedGraph.addVertex(v)
            }
            
            for edge in rawGraph.edgeList() {
                refinedGraph.addEdge(from: rawGraph.vertexAtIndex(edge.u), to: rawGraph.vertexAtIndex(edge.v), directed: true, role: edge.roles)
            }
            
            /// Create the groups
            let rawGraphClustered: [DependencyGraph<Node>] = clusterByClasses(originalGraph: rawGraph)

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
