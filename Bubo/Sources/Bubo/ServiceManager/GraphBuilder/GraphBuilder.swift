//
//  Created by Valentin Hartig on 12.05.20.
//

import Foundation
import SwiftGraph
import SwiftSyntax
import IndexStoreDB

class GraphBuilder {
    public private(set) var graph: DependencyGraph<Node>
    var tokens: [Token]
    var tokenExtensions: [String:Token]
    
    let indexDatabaseConfiguration: IndexDatabaseConfiguration?
    let indexDatabase: IndexDatabase?
    let indexingServer: IndexingServer?
    
    
    init(tokens: [Token], tokenExtensions: [String:Token], service: Service) {
        self.graph = DependencyGraph<Node>()
        self.tokens = tokens
        self.tokenExtensions = tokenExtensions
        
        guard let serviceRoot: URL = service.packageDotSwift?.fileURL.deletingPathExtension().deletingLastPathComponent() else {
            errorMessage(msg: "Can't get the root path to service \(service.name) to genereate indexstore path")
            abortMessage(msg: "Graphbuild initialisation")
            self.tokens = []
            self.indexDatabase = nil
            self.indexingServer = nil
            self.indexDatabaseConfiguration = nil
            return
        }
        
        let indexStorePath = serviceRoot
            .appendingPathComponent(".build")
            .appendingPathComponent("debug")
            .appendingPathComponent("index")
            .appendingPathComponent("store")
        
        self.indexDatabaseConfiguration = IndexDatabaseConfiguration(indexStorePath: indexStorePath, indexDatabasePath: nil)
        
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
        indexDatabase?.index?.pollForUnitChangesAndWait()
        self.indexingServer = IndexingServer(indexDatabase: self.indexDatabase)
    }
    
    public func createDependencyGraph() -> Void {
        for token in tokens {
            createNode(token: token)
        }
    }
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
        
        for node in graph.vertices {
            if node.kind == .class || node.kind == .struct {
                for extensionNode in graph.vertices {
                    if
                        extensionNode.kind == .extension
                        && extensionNode.name == node.name
                        && !graph.edgeExists(from: node, to: extensionNode, role: .extendedBy)
                    {
                        graph.addEdge(from: node, to: extensionNode, directed: true, role: .extendedBy)
                    }
                }
            }
        }
        
        for node in graph.vertices {
            for role in EdgeRole.allCases {
                if let symbolRole: SymbolRole = EdgeRole.getSymbolRole(edgeRole: role){
                    let symbolOccurrences = indexingServer.findRelatedSymbols(ofUSR: node.usr, role: symbolRole)
                    for occurrence in symbolOccurrences {
                        guard let occURL: URL = URL(fileURLWithPath: occurrence.location.path) else {
                            errorMessage(msg: "Cant create URL of this path \(occurrence.location.path)")
                            return
                        }
                        if !occURL.pathComponents.contains(".build") { // IMPORTANT!!!! IF NOT ALL EXTERNAL DEPENDENCIES ARE SCANNED TOO 
                            if !occurrence.location.isSystem {
                                let node = Node(symbol: occurrence.symbol)
                                if !graph.contains(node) {
                                    graph.addVertex(node)
                                }
                                for relation in occurrence.relations {
                                    let relatedNode = Node(symbol: relation.symbol)
                                    if !graph.contains(relatedNode) {
                                        graph.addVertex(relatedNode)
                                    }
                                    let role = EdgeRole(symbolRole: relation.roles)
                                    if !graph.edgeExists(from: node, to: relatedNode, role: role) {
                                        graph.addEdge(from: node, to: relatedNode, directed: true, role: role)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
