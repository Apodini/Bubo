//
//  Created by Valentin Hartig on 12.05.20.
//

import Foundation
import SwiftGraph
import SwiftSyntax
import IndexStoreDB

class GraphBuilder {
    public private(set) var graph: DependencyGraph<Node>
    
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
    
    
    init(tokens: [Token], tokenExtensions: [String:Token], service: Service) {
        self.graph = DependencyGraph<Node>()
        self.tokens = tokens
        self.tokenExtensions = tokenExtensions
        
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
        
        /// Intate the databse to read and process data at the indexpath and wait for the process to finish
        indexDatabase?.index?.pollForUnitChangesAndWait()
        self.indexingServer = IndexingServer(indexDatabase: self.indexDatabase)
    }
    
    public func createDependencyGraph() -> Void {
        /// Create the basic nodes from the parsed tokens
        for token in tokens {
            createNode(token: token)
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
        
        guard let indexingServer = self.indexingServer else {
            errorMessage(msg: "Can't get indexing server")
            abortMessage(msg: "Dependency graph creation")
            return
        }
        
        /// Find all relations between all nodes and missed nodes
            var queue: Queue = Queue<Node>()
            for node in graph.vertices {
                queue.push(node)
            }
            
            while !queue.isEmpty {
                let node = queue.pop()
//                outputMessage(msg: "\(queue.count)")
                for role in EdgeRole.allCases {
                    if let symbolRole: SymbolRole = EdgeRole.getSymbolRole(edgeRole: role) {
                        /// Get all rlated symbols for a node
                        let symbolOccurrences = indexingServer.findRelatedSymbols(ofUSR: node.usr, role: symbolRole)
                        for occurrence in symbolOccurrences {
                            /// Check if the symbol occurence is part of an imported project
                            guard let occURL: URL = URL(fileURLWithPath: occurrence.location.path) else {
                                errorMessage(msg: "Cant create URL of this path \(occurrence.location.path)")
                                return
                            }
                            if !occURL.pathComponents.contains(".build") { // IMPORTANT!!!! IF NOT ALL EXTERNAL DEPENDENCIES ARE SCANNED TOO
                                if !occurrence.location.isSystem {
                                    let occNode = Node(symbol: occurrence.symbol)
                                    
                                    /// Check if the node already exists (compares by usr), if not add it to the nodes and to the queue
                                    if !graph.contains(occNode) {
                                        graph.addVertex(occNode)
                                        queue.push(occNode)
                                    }
                                    
                                    /// Scan all relations of the symbol
                                    for relation in occurrence.relations {
                                        let relatedNode = Node(symbol: relation.symbol)
                                        /// Check if the node already exists (compares by usr), if not add it to the nodes and to the queue
                                        if !graph.contains(relatedNode) {
                                            graph.addVertex(relatedNode)
                                            queue.push(relatedNode)
                                        }
                                        
                                        /// Check if there is an already existing edge between the node and the related nodecand genereate dge if not
                                        let role = EdgeRole.getEdgeRoles(symbolRole: relation.roles)
                                        if !graph.edgeExists(from: occNode, to: relatedNode, role: role) {
                                            graph.addEdge(from: occNode, to: relatedNode, directed: true, role: role)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
//    OLD VERSION OF SEARCH ALGO: DOSEN'T WORK CORRECTLY --> use Queue verison
//    private func enhance(indexingServer: IndexingServer) -> Void {
//        for node in graph.vertices {
//            for role in EdgeRole.allCases {
//                if let symbolRole: SymbolRole = EdgeRole.getSymbolRole(edgeRole: role){
//                    let symbolOccurrences = indexingServer.findRelatedSymbols(ofUSR: node.usr, role: symbolRole)
//                    for occurrence in symbolOccurrences {
//                        guard let occURL: URL = URL(fileURLWithPath: occurrence.location.path) else {
//                            errorMessage(msg: "Cant create URL of this path \(occurrence.location.path)")
//                            return
//                        }
//                        if !occURL.pathComponents.contains(".build") { // IMPORTANT!!!! IF NOT ALL EXTERNAL DEPENDENCIES ARE SCANNED TOO
//                            if !occurrence.location.isSystem {
//                                let node = Node(symbol: occurrence.symbol)
//                                if !graph.contains(node) {
//                                    graph.addVertex(node)
//                                }
//                                for relation in occurrence.relations {
//                                    let relatedNode = Node(symbol: relation.symbol)
//                                    if !graph.contains(relatedNode) {
//                                        graph.addVertex(relatedNode)
//                                    }
//                                    let role = EdgeRole.getEdgeRoles(symbolRole: relation.roles)
//                                    if !graph.edgeExists(from: node, to: relatedNode, role: role) {
//                                        graph.addEdge(from: node, to: relatedNode, directed: true, role: role)
//                                    }
//                                }
//                            }
//                        }
//                    }
//                }
//            }
//        }
//    }
}

extension GraphBuilder {
    private func createNode(token: Token) -> Void {
        guard let indexingServer = self.indexingServer else {
            errorMessage(msg: "Can't get indexing server")
            abortMessage(msg: "Dependency graph creation")
            return
        }
        let symbolOccurrences = indexingServer.findWorkspaceSymbols(matching: token.name)
        for occurrence in symbolOccurrences {
            let node = Node(symbol: occurrence.symbol)
            if !graph.contains(node) {
                graph.addVertex(node)
            }
        }
    }
}
