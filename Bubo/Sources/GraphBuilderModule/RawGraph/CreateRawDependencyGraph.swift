//
//  Created by Valentin Hartig on 30.06.20.
//

import Foundation
import IndexStoreDB
import BuboModelsModule
import OutputStylingModule

extension GraphBuilder {
    
    /// Builds the dependency graph
     func generateRawDependencyGraph() -> RawDependencyGraph<Node>? {
        headerMessage(msg: "Building graph")
        
        /// Find all relations between all nodes and missed nodes
        var queue: [Symbol] = [Symbol]()
        
        /// Unwrap IndexingServer
        guard let indexingServer = self.indexingServer else {
            errorMessage(msg: "Can't get indexing server")
            abortMessage(msg: "Dependency graph creation")
            return nil
        }
        
        /// Get all symbols for generated tokns
        for token in self.parser.tokens {
            for occ in indexingServer.findWorkspaceSymbols(matching: token.name) {
                /// Do not add duplicates
                if !queue.contains(where: {(sym: Symbol) -> Bool in sym.usr == occ.symbol.usr && sym.kind == occ.symbol.kind}) {
                    queue.append(occ.symbol)
                }
            }
        }
        
        /// Recursively find all nodes
        let toBeNodes = breadthFirstSymbolDiscovery(inQueue: queue, indexingServer: indexingServer)
        
        return createRawDependencyGraph(symbolOccurences: [SymbolOccurrence](toBeNodes.values))
    }
    
    private func createRawDependencyGraph(symbolOccurences: [SymbolOccurrence]) -> RawDependencyGraph<Node> {
        outputMessage(msg: "Creating nodes")
        let graph: RawDependencyGraph<Node> = RawDependencyGraph<Node>()
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
        
        outputMessage(msg: "Creating edges")
        /// Create Edges
        for (symbol, relation) in relations.value {
            if let index = graph.vertices.firstIndex(where: { (node: Node) -> Bool in return node.usr == symbol.usr}) {
                let fromNode: Node = graph.vertexAtIndex(index)
                if let index = graph.vertices.firstIndex(where: { (node: Node) -> Bool in return node.usr == relation.symbol.usr}) {
                    let toNode: Node = graph.vertexAtIndex(index)
                    /// Check if there is an already existing edge between the node and the related node and genereate edge if not
                    let roles = EdgeRole.getEdgeRoles(symbolRole: relation.roles)
                    if !graph.edgeExists(from: fromNode, to: toNode, role: roles) {
                        graph.addEdge(from: fromNode, to: toNode, directed: true, role: roles)
                    }
                }
            }
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
        return graph
    }
}
