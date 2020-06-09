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
    
    let indexDatabaseConfiguration: IndexDatabaseConfiguration?
    let indexDatabase: IndexDatabase?
    let indexingServer: IndexingServer?
    
    
    init(tokens: [Token], service: Service) {
        self.graph = DependencyGraph<Node>()
        self.tokens = tokens
        guard let serviceRoot: URL = service.packageDotSwift?.fileURL.deletingPathExtension().deletingLastPathComponent() else {
            errorMessage(msg: "Can't get the root path to service \(service.name) to genereate indexstore path")
            abortMessage(msg: "Graphbuild initialisation")
            self.tokens = []
            self.indexDatabase = nil
            self.indexingServer = nil
            self.indexDatabaseConfiguration = nil
            return
        }
        let indexStorePath = serviceRoot            .appendingPathComponent(".build")
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
            for relation in occurrence.relations {
                let relatedNode = Node(symbol: relation.symbol)
                if !graph.contains(relatedNode) {
                    graph.addVertex(relatedNode)
                }
                let role = EdgeRole(symbolRole: relation.roles)
                if !graph.edgeExists(from: relatedNode, to: node, role: role) {
                    graph.addEdge(from: relatedNode, to: node, directed: true, role: EdgeRole(symbolRole: relation.roles))
                }
            }
        }
    }
    
}
