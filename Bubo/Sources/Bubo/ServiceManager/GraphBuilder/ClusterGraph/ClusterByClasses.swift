//
//  Created by Valentin Hartig on 23.06.20.
//

import Foundation

extension GraphBuilder {
    
    public func clusterByClasses(originalGraph: DependencyGraph<Node>) -> [DependencyGraph<Node>] {
        var reducedGraph: DependencyGraph<Node> = DependencyGraph<Node>()
        
        for v in originalGraph.vertices {
            reducedGraph.addVertex(v)
        }
        
        for edges in originalGraph.edges {
            for edge in edges {
                if edge.roles.contains(.childOf) || edge.roles.contains(.extendedBy){
                    reducedGraph.addEdge(from: originalGraph.vertexAtIndex(edge.v), to: originalGraph.vertexAtIndex(edge.u), directed: true, role: edge.roles)
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
            var graph: DependencyGraph<Node> = DependencyGraph<Node>()
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
