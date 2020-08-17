//
//  Created by Valentin Hartig on 30.06.20.
//

import Foundation
import IndexStoreDB
import ResourceManagerModule

extension GraphBuilder {
    
    /// Builds the dependency graph
     func generateRawDependencyGraph() -> DependencyGraph<Node>? {
        headerMessage(msg: "Building graph")
        
        /// Find all relations between all nodes and missed nodes
        var queue: ThreadSafeArray<Symbol> = ThreadSafeArray<Symbol>()
        
        /// Unwrap IndexingServer
        guard let indexingServer = self.indexingServer else {
            errorMessage(msg: "Can't get indexing server")
            abortMessage(msg: "Dependency graph creation")
            return nil
        }
        
        /// Get all symbols for generated tokns
        outputMessage(msg: "Querying parsed tokens in the indexing database")
        var queueMemory: ThreadSafeSet<SymbolOccurenceHashToken> = ThreadSafeSet<SymbolOccurenceHashToken>()
        
        DispatchQueue.concurrentPerform(iterations: self.parser.tokens.count) { index in
            var tmpQueue: [Symbol] = [Symbol]()
            for occ in indexingServer.findSymbolsMatchingName(matching: self.parser.tokens[index].name) {
                /// Do not add duplicates
                let symOccHash: SymbolOccurenceHashToken = SymbolOccurenceHashToken (usr: occ.symbol.usr, kind: occ.symbol.kind, roles: occ.roles, path: occ.location.path, isSystem: occ.location.isSystem, line: occ.location.line, utf8Column: occ.location.utf8Column)
                if !queueMemory.contains(element: symOccHash) {
                    tmpQueue.append(occ.symbol)
                }
            }
            queue.append(elements: tmpQueue)
        }
        
        /// Recursively find all nodes
        let toBeNodes = breadthFirstSymbolDiscovery(inQueue: queue.value, indexingServer: indexingServer)
        print("toBeNodes: \(toBeNodes.capacity)")
        return createRawDependencyGraph(symbolOccurences: [SymbolOccurrence](toBeNodes.values))
    }
    
    private func createRawDependencyGraph(symbolOccurences: [SymbolOccurrence]) -> DependencyGraph<Node> {
        outputMessage(msg: "Creating nodes")
        let graph: DependencyGraph<Node> = DependencyGraph<Node>()
        /// Check filtered symbols
        var relations: ThreadSafeArray<(Symbol,SymbolRelation)> = ThreadSafeArray<(Symbol,SymbolRelation)>()
        var safeNodes: ThreadSafeArray<Node> = ThreadSafeArray<Node>()
        DispatchQueue.concurrentPerform(iterations: symbolOccurences.count) { index in
            let occ: SymbolOccurrence = symbolOccurences[index]
            safeNodes.append(elements: [Node(symbol: occ.symbol, roles: occ.roles, location: occ.location)])
            
            /// Scan all relations of the symbol
            DispatchQueue.concurrentPerform(iterations: occ.relations.count) { index in
                relations.append(elements: [(occ.symbol, occ.relations[index])])
            }
        }
        for node in safeNodes.value {
            graph.addVertex(node)
        }
        successMessage(msg: "Nodes created")
        outputMessage(msg: "Creating edges")
        /// Create Edges
        
        var edges: ThreadSafeArray<DependencyEdge> = ThreadSafeArray<DependencyEdge>()
        
        DispatchQueue.concurrentPerform(iterations: relations.count) { index in
            let (symbol, relation) = relations[index]
            if let u = graph.vertices.firstIndex(where: { (node: Node) -> Bool in return node.usr == symbol.usr}) {
                if let v = graph.vertices.firstIndex(where: { (node: Node) -> Bool in return node.usr == relation.symbol.usr}) {
                    /// Check if there is an already existing edge between the node and the related node and genereate edge if not
                    let roles = EdgeRole.getEdgeRoles(symbolRole: relation.roles)
                    if !graph.edgeExists(fromIndex: u, toIndex: v, role: roles) {
                        edges.append(elements: [DependencyEdge(u: u, v: v, directed: true, roles: roles)])
                    }
                }
            }
        }
        
        for edge in edges.value {
            graph.addEdge(edge, directed: true)
        }
        
        /// Connect all extensions to their classes or structs
        for node in graph.vertices {
            if node.kind == .class || node.kind == .struct {
                for extensionNode in graph.vertices {
                    if
                        extensionNode.kind == .extension
                            && extensionNode.name == node.name
                            && !graph.edgeExists(from: node, to: extensionNode, role: [.extendedBy])
                    {
                        graph.addEdge(from: node, to: extensionNode, directed: true, role: [.extendedBy])
                    }
                }
            }
        }
        successMessage(msg: "Edges created")
        return graph
    }
}
