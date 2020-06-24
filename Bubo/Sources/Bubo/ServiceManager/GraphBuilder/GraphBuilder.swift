//
//  Created by Valentin Hartig on 12.05.20.
//

import Foundation
import SwiftGraph
import SwiftSyntax
import IndexStoreDB


/// Creates a dependency graph for a service (a Swift package) based on a set of parsed tokens from a syntax parser
/// and the raw indexing data of a build process of the service
class GraphBuilder {
    public var graph: DependencyGraph<Node>
    
    /// Tokens generated by parsing the raw syntax of all swift files
    var tokens: [Token]
    
    /// Token Extesnions
    var tokenExtensions: [String:Token]
    
    
    /// Configuration for the indexing database
    let indexDatabaseConfiguration: IndexDatabaseConfiguration?
    
    /// The indexing database which is queried by the indexing server
    let indexDatabase: IndexDatabase?
    
    /// The indexing server that contains all queries that can be run on the indexing database
    let indexingServer: IndexingServer?
    
    /// All permutaions of NodeRoles that are shorter then 3
    let nodeRoleCombinations: [SymbolRole]
    
    /// All permutaions of EdgeRoles that are shorter then 3
    let edgeRoleCombinations: [SymbolRole]
    
    
    /// Constructs a GraphBuilder object and initialises the indexing server needed to query raw indexing data
    init(tokens: [Token], tokenExtensions: [String:Token], service: ServiceConfiguration) {
        outputMessage(msg: "Initialising graph builder...")
        self.graph = DependencyGraph<Node>()
        self.tokens = tokens
        self.tokenExtensions = tokenExtensions
        
        outputMessage(msg: "Generating edge and node role permutaions")
        self.nodeRoleCombinations = NodeRole.getAllRoleCombinations()
        self.edgeRoleCombinations = EdgeRole.getAllRoleCombinations()
        /// Building the index store path --> this is the path where the raw indexing data generated by the compiler during build process lies
        let indexStorePath = service.gitRootURL
            .appendingPathComponent(".build")
            .appendingPathComponent("debug")
            .appendingPathComponent("index")
            .appendingPathComponent("store")
        
        /// Gernerating the indexing database configuration
        self.indexDatabaseConfiguration = IndexDatabaseConfiguration(indexStorePath: indexStorePath, indexDatabasePath: nil)
        
        /// Generating the indexing database with passed configuration
        do {
            try self.indexDatabase = IndexDatabase(indexDBConfig: self.indexDatabaseConfiguration!)
        } catch {
            self.indexDatabase = nil
            errorMessage(msg: "Can't build index database. Has the project been built?")
        }
        guard indexDatabase != nil else {
            errorMessage(msg: "Failed to initialise indexingServer: No indexingDatabase")
            self.indexingServer = nil
            return
        }
        
        /// Initiate the databse to read and process data at the indexpath and wait for the process to finish
        indexDatabase?.index?.pollForUnitChangesAndWait()
        self.indexingServer = IndexingServer(indexDatabase: self.indexDatabase)
    }
    
    
    /// Builds the dependency graph
    
    public func createDependencyGraph() -> Void {
        headerMessage(msg: "Building graph")
        
        /// Find all relations between all nodes and missed nodes
        var queue: Queue = Queue<Symbol>()
        
        guard let indexingServer = self.indexingServer else {
            errorMessage(msg: "Can't get indexing server")
            abortMessage(msg: "Dependency graph creation")
            return
        }
        
        /// Get all symbols for generated tokns
        for token in tokens {
            for occ in indexingServer.findWorkspaceSymbols(matching: token.name) {
                queue.push(occ.symbol)
            }
        }
        
        /// Recursively find all nodes
        iterativeGraphBuilder(queue: queue, indexingServer: indexingServer)
        
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
    }
}

extension GraphBuilder {
    
    private func iterativeGraphBuilder(queue: Queue<Symbol>, indexingServer: IndexingServer) -> Void {
        var relations: [(Symbol,SymbolRelation)] = [(Symbol,SymbolRelation)]()
        var visited: [Symbol] = [Symbol]()
        while !queue.isEmpty {
            let symbol = queue.pop()
            
            /// Check if symbol has already been visited
            if !visited.contains(where: {(sym: Symbol) -> Bool in sym.usr == symbol.usr && sym.kind == symbol.kind}) {
                visited.append(symbol)
                let symbolOccurrences = self.getSymbolOccurences(symbol: symbol, indexingServer: indexingServer)
                for occurrence in symbolOccurrences {
                    /// Check if the symbol occurence is part of an imported project
                    guard let occURL: URL = URL(fileURLWithPath: occurrence.location.path) else {
                        errorMessage(msg: "Cant create URL of this path \(occurrence.location.path)")
                        return
                    }
                    if !occURL.pathComponents.contains(".build") { // IMPORTANT!!!! IF NOT ALL EXTERNAL DEPENDENCIES ARE SCANNED TOO
                        if !occurrence.location.isSystem {
                            let occNode = Node(symbol: occurrence.symbol, roles: occurrence.roles)
                            
                            /// Check if the node already exists (compares by usr), if not add it to the nodes and to the queue
                            if !graph.contains(where: { (node: Node) -> Bool in return node.usr == occurrence.symbol.usr}) {
                                graph.addVertex(occNode)
                                queue.push(occurrence.symbol)
                            } else {
                                if let index = graph.vertices.firstIndex(where: { (node: Node) -> Bool in return node.usr == occurrence.symbol.usr}) {
                                    if let node: Node = graph.vertexAtIndex(index) {
                                        var roles: [NodeRole] = [NodeRole](node.roles)
                                        for role in occNode.roles {
                                            if !roles.contains(role) {
                                                roles.append(role)
                                            }
                                        }
                                        /// Update vertex if new roles are discovered
                                        graph.removeVertex(node)
                                        node.roles = roles
                                        graph.addVertex(node)
                                    }
                                }
                            }
                            
                            /// Scan all relations of the symbol
                            for relation in occurrence.relations {
                                /// Check if the graph contains a node with the symbol usr
                                if !graph.contains(where: { (node: Node) -> Bool in return node.usr == relation.symbol.usr}) {
                                    queue.push(relation.symbol)
                                }
                                relations.append((occurrence.symbol,relation))
                            }
                        }
                    }
                }
            }
        }
        /// Create Edges
        for (symbol, relation) in relations {
            if let index = graph.vertices.firstIndex(where: { (node: Node) -> Bool in return node.usr == symbol.usr}) {
                if let fromNode: Node = graph.vertexAtIndex(index) {
                    if let index = graph.vertices.firstIndex(where: { (node: Node) -> Bool in return node.usr == relation.symbol.usr}) {
                        if let toNode: Node = graph.vertexAtIndex(index) {
                            /// Check if there is an already existing edge between the node and the related node and genereate edge if not
                            let roles = EdgeRole.getEdgeRoles(symbolRole: relation.roles)
                            if !graph.edgeExists(from: fromNode, to: toNode, role: roles) {
                                graph.addEdge(from: fromNode, to: toNode, directed: true, role: roles)
                            }
                        }
                    }
                }
            }
        }
    }
    
    
//    private func getSymbolOccurences(symbol: Symbol, indexingServer: IndexingServer) -> [SymbolOccurrence] {
//        // This takes a lot of time but making it concurrent dosen't work ......
//        var symbolOccurrences: [SymbolOccurrence] = [SymbolOccurrence]()
//
//        for nodeRole in nodeRoleCombinations {
//            symbolOccurrences.append(contentsOf: indexingServer.occurrences(ofUSR: symbol.usr, roles: nodeRole))
//        }
//
//        for edgeRole in edgeRoleCombinations {
//            symbolOccurrences.append(contentsOf: indexingServer.findRelatedSymbols(relatedToUSR: symbol.usr, roles: edgeRole))
//        }
//        return symbolOccurrences
//    }
    
    private func getSymbolOccurences(symbol: Symbol, indexingServer: IndexingServer) -> [SymbolOccurrence] {

        var safeSymbolOccurrences = ThreadSafe<SymbolOccurrence>()

        DispatchQueue.concurrentPerform(iterations: nodeRoleCombinations.count) { index in
            let occurences = indexingServer.occurrences(ofUSR: symbol.usr, roles: nodeRoleCombinations[index])
            safeSymbolOccurrences.append(elements: occurences)
        }

        DispatchQueue.concurrentPerform(iterations: edgeRoleCombinations.count) { index in
            let occurences = indexingServer.findRelatedSymbols(relatedToUSR: symbol.usr, roles: edgeRoleCombinations[index])
            safeSymbolOccurrences.append(elements: occurences)
        }

        print("All occurences: \(safeSymbolOccurrences.value.count)")
        return safeSymbolOccurrences.value
    }
}
