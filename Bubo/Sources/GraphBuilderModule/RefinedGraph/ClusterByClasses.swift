//
//  SymbolHashToken.swift
//  Bubo
//
//  Created by Valentin Hartig on 23/06/20
//  Copyright © 2020 TUM LS1. All rights reserved.
//

import Foundation
import ResourceManagerModule


// MARK: GraphBuilder
extension GraphBuilder {
    
    
    /// Cluster a dependency graph by its highlevel entities and retrun all connected componets of the graph, only containing childOf and extensionOf Relationships
    /// - parameter originalGraph: The graph that should be assigned groupIDs
    /// - returns: An array of connected components
    public func clusterByClasses(originalGraph: DependencyGraph<Node>) -> [DependencyGraph<Node>] {
        let reducedGraph: DependencyGraph<Node> = DependencyGraph<Node>()
        
        for v in originalGraph.vertices {
            reducedGraph.addVertex(v)
        }
        
        for edges in originalGraph.edges {
            for edge in edges {
                if edge.roles.contains(.childOf) || edge.roles.contains(.extendedBy){
                    reducedGraph.addEdge(from: originalGraph.vertexAtIndex(edge.u), to: originalGraph.vertexAtIndex(edge.v), directed: true, role: edge.roles)
                }
            }
        }
        /// Use depth first search to find all connected Components
        var visited: [Bool] = Array(repeating: false, count: reducedGraph.vertices.count)
        var components: [[Node]] = [[Node]()]
        for v in reducedGraph.vertices {
            if let vIndex = reducedGraph.indexOfVertex(v) {
                if !visited[vIndex] {
                    let (vis, comp) = depthFirstSearch(node: vIndex, visited: visited, component: [], reducedGraph: reducedGraph)
                    visited = vis
                    components.append(comp)
                }
            }
        }
        
        var safeGraphArray: ThreadSafeArray<DependencyGraph<Node>> = ThreadSafeArray<DependencyGraph<Node>>()
        DispatchQueue.concurrentPerform(iterations: components.count) { index in
            let graph: DependencyGraph<Node> = DependencyGraph<Node>()
            for node in components[index] {
                graph.addVertex(node)
            }
            for edge in reducedGraph.edgeList() {
                if components[index].contains(reducedGraph.vertexAtIndex(edge.v)) && components[index].contains(reducedGraph.vertexAtIndex(edge.u)){
                    graph.addEdge(from: reducedGraph.vertexAtIndex(edge.v), to: reducedGraph.vertexAtIndex(edge.u), directed: true, role: edge.roles)
                }
            }
            if graph.vertices.count > 0 {
                safeGraphArray.append(elements: [graph])
            }
        }
        
        return safeGraphArray.value
    }
    
    /// A recursive depth first search that searches connected components for a given node, idetified by its position in the graphs vertecies array.
    /// - parameters:
    ///     - node the index node that is currently processed
    ///     - visited all nodes that have been visited identified by their index in the vertices array in the graph
    ///     - component the aggregator for the connected component that is currently generated
    ///     - reducedGraph: The graph that is searched
    /// - note: This algorithm is very slow, please optimise it :(
    
    private func depthFirstSearch(node: Int, visited: [Bool], component: [Node], reducedGraph: DependencyGraph<Node>) -> ([Bool],[Node]) {
        
        var visited: [Bool] = visited
        var component: [Node] = component
        
        for edge in reducedGraph.edgeList() {
            if edge.u == node {
                if !visited[edge.v] {
                    visited[edge.v] = true
                    component.append(reducedGraph.vertexAtIndex(edge.v))
                    let (vis, comp) = depthFirstSearch(node: edge.v, visited: visited, component: component, reducedGraph: reducedGraph)
                    visited = vis
                    component = comp
                }
            } else if edge.v == node {
                if !visited[edge.u] {
                    visited[edge.u] = true
                    component.append(reducedGraph.vertexAtIndex(edge.u))
                    let (vis, comp) = depthFirstSearch(node: edge.u, visited: visited, component: component, reducedGraph: reducedGraph)
                    visited = vis
                    component = comp
                }
            }
        }
        return (visited, component)
    }
}
