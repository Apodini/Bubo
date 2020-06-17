//
//  Created by Valentin Hartig on 17.05.20.
//

import Foundation
import SwiftGraph
import SwiftSyntax


/// Extension of **SwiftGraph**'s `Graph` class that models a swift dependency graph
open class DependencyGraph<V: Equatable & Codable>: Graph {
    public var vertices: [V] = [V]()
    public var edges: [[DependencyEdge]] = [[DependencyEdge]]() //adjacency lists
    
    public init() {
    }
    
    required public init(vertices: [V]) {
        for vertex in vertices {
            _ = self.addVertex(vertex)
        }
    }
    
    /// Add an edge to the graph.
    ///
    /// - parameter e: The edge to add.
    /// - parameter directed: If false, undirected edges are created.
    ///                       If true, a reversed edge is also created.
    ///                       Default is false.
    public func addEdge(_ e: DependencyEdge, directed: Bool) {
        edges[e.u].append(e)
        if !directed && e.u != e.v {
            edges[e.v].append(e.reversed())
        }
    }
    
    /// Add a vertex to the graph.
    ///
    /// - parameter v: The vertex to be added.
    /// - returns: The index where the vertex was added.
    public func addVertex(_ v: V) -> Int {
        vertices.append(v)
        edges.append([E]())
        return vertices.count - 1
    }
    
    /// Implement `CustomStringConvertible` protocol
    /// - note: Outputs the graph in `.dot` format
    public var description: String {
        var vertices: String = ""
        for v in self.vertices {
            if edgesForIndex(indexOfVertex(v)!).count <= 0 {
                vertices += "\"\(v)\"; \n"
            }
        }
        var graph: String = "digraph G {\n"
        for vertex in self.vertices {
            for edge in edgesForIndex(indexOfVertex(vertex)!) {
                var roles = ""
                for role in edge.roles {
                    roles += " \(role) |"
                }
                graph += "\"\(vertexAtIndex(edge.u))\" -> \"\(vertexAtIndex(edge.v))\" [ label=\"\(roles.dropLast())\" ];\n"
            }
        }
        
        return graph + "}"
    }
}

/// Adjust **SwiftGraph**'s functions to accept edges of type `DependencyEdge`
extension Graph where E == DependencyEdge {

    /// Initialize an UnweightedGraph consisting of path.
    ///
    /// The resulting graph has the vertices in path and an edge between
    /// each pair of consecutive vertices in path.
    ///
    /// If path is an empty array, the resulting graph is the empty graph.
    /// If path is an array with a single vertex, the resulting graph has that vertex and no edges.
    ///
    /// - Parameters:
    ///   - path: An array of vertices representing a path.
    ///   - directed: If false, undirected edges are created.
    ///               If true, edges are directed from vertex i to vertex i+1 in path.
    ///               Default is false.
    
    /// - note: THIS FUNCTION IS CURRENTLY NOT REWORKED FOR DEPENDENCY GARPHS
    public static func withPath(_ path: [(V,[EdgeRole])], directed: Bool = false) -> Self {
        
        var vertices: [V] = []
        var edgeRoles: [[EdgeRole]] = []
        
        for (v,e) in path {
            vertices.append(v)
            edgeRoles.append(e)
        }
        
        let g = Self(vertices: vertices)

        guard path.count >= 2 else {
            return g
        }

        for i in 0..<path.count - 1 {
            g.addEdge(fromIndex: i, toIndex: i+1, directed: directed, role: edgeRoles[i])
        }
        return g
    }

    /// Initialize an UnweightedGraph consisting of cycle.
    ///
    /// The resulting graph has the vertices in cycle and an edge between
    /// each pair of consecutive vertices in cycle,
    /// plus an edge between the last and the first vertices.
    ///
    /// If cycle is an empty array, the resulting graph is the empty graph.
    /// If cycle is an array with a single vertex, the resulting graph has the vertex
    /// and a single edge to itself if directed is true.
    /// If directed is false the resulting graph has the vertex and two edges to itself.
    ///
    /// - Parameters:
    ///   - cycle: An array of vertices representing a cycle.
    ///   - directed: If false, undirected edges are created.
    ///               If true, edges are directed from vertex i to vertex i+1 in cycle.
    ///               Default is false.
    
    /// - note: THIS FUNCTION IS CURRENTLY NOT REWORKED FOR DEPENDENCY GARPHS
    public static func withCycle(_ cycle: [(V, [EdgeRole])], directed: Bool = false) -> Self {
        let g = Self.withPath(cycle, directed: directed)
        if cycle.count > 0 {
            //g.addEdge(fromIndex: cycle.count-1, toIndex: 0, directed: directed)
        }
        return g
    }
    
    /// This is a convenience method that adds an unweighted edge.
    ///
    /// - parameter from: The starting vertex's index.
    /// - parameter to: The ending vertex's index.
    /// - parameter directed: Is the edge directed? (default `false`)
    public func addEdge(fromIndex: Int, toIndex: Int, directed: Bool = false, role: [EdgeRole]) {
        addEdge(DependencyEdge(u: fromIndex, v: toIndex, directed: directed, roles: role), directed: directed)
    }
    
    /// This is a convenience method that adds an unweighted, undirected edge between the first occurence of two vertices. It takes O(n) time.
    ///
    /// - parameter from: The starting vertex.
    /// - parameter to: The ending vertex.
    /// - parameter directed: Is the edge directed? (default `false`)
    public func addEdge(from: V, to: V, directed: Bool = false, role: [EdgeRole]) {
        if let u = indexOfVertex(from), let v = indexOfVertex(to) {
            addEdge(DependencyEdge(u: u, v: v, directed: directed, roles: role), directed: directed)
        }
    }

    /// Check whether there is an edge from one vertex to another vertex.
    ///
    /// - parameter from: The index of the starting vertex of the edge.
    /// - parameter to: The index of the ending vertex of the edge.
    /// - returns: True if there is an edge from the starting vertex to the ending vertex.
    public func edgeExists(fromIndex: Int, toIndex: Int, role: [EdgeRole]) -> Bool {
        // The directed property of this fake edge is ignored, since it's not taken into account
        // for equality.
        return edgeExists(E(u: fromIndex, v: toIndex, directed: true, roles: role))
    }

    /// Check whether there is an edge from one vertex to another vertex.
    ///
    /// Note this will look at the first occurence of each vertex.
    /// Also returns false if either of the supplied vertices cannot be found in the graph.
    ///
    /// - parameter from: The starting vertex of the edge.
    /// - parameter to: The ending vertex of the edge.
    /// - returns: True if there is an edge from the starting vertex to the ending vertex.
    public func edgeExists(from: V, to: V, role: [EdgeRole]) -> Bool {
        if let u = indexOfVertex(from) {
            if let v = indexOfVertex(to) {
                for edge in edges[u] {
                    if edge.v == v && edge.roles.count == role.count {
                        var flag: Bool = true
                        for r in edge.roles {
                            if !role.contains(r) {
                                flag = false
                            }
                        }
                        if flag {
                            return flag
                        }
                    }
                }
            //    return edgeExists(fromIndex: u, toIndex: v, role: role)
            }
        }
        return false
    }
}
