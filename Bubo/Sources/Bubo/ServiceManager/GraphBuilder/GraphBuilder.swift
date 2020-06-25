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
        var queue: [Symbol] = [Symbol]()
        
        guard let indexingServer = self.indexingServer else {
            errorMessage(msg: "Can't get indexing server")
            abortMessage(msg: "Dependency graph creation")
            return
        }
        
        /// Get all symbols for generated tokns
        for token in tokens {
            for occ in indexingServer.findWorkspaceSymbols(matching: token.name) {
                /// Do not add duplicates
                if !queue.contains(where: {(sym: Symbol) -> Bool in sym.usr == occ.symbol.usr && sym.kind == occ.symbol.kind}) {
                    queue.append(occ.symbol)
                }
            }
        }
        
        /// Recursively find all nodes
        iterativeGraphBuilder(inQueue: queue, indexingServer: indexingServer)
        
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
    
    private func iterativeGraphBuilder(inQueue: [Symbol], indexingServer: IndexingServer) -> Void {
        var queue: ThreadSafeArray<Symbol> = ThreadSafeArray<Symbol>(inQueue)
        var visited: [Symbol] = [Symbol]()
        var queueMemory: ThreadSafeArray<Symbol> = ThreadSafeArray<Symbol>(inQueue) // one half is queue the other half is visited
        var alreadyProcessing: [SymbolOccurrence] = [SymbolOccurrence]()
        var toBeNodes: ThreadSafeDictionary = ThreadSafeDictionary()
        outputMessage(msg: "Querying nodes")
        while !queue.value.isEmpty {
            print("Queue length: \(queue.value.count)")
            let symbol = queue.removeFirst()
            /// Check if symbol has already been visited
            if !visited.contains(where: {(sym: Symbol) -> Bool in sym.usr == symbol.usr && sym.kind == symbol.kind}) {
                
                /// Concurrently get all symbol occurences and related symbol occurences for queue symbol
                let symbolOccurrences = self.getSymbolOccurences(symbol: symbol, indexingServer: indexingServer)
                
                /// Sort alreadyProcessing array to optimise binary search
                alreadyProcessing.sort()
                
                /// Concurrently fIlter all occurences for already visited occurences and location
                var safeSymbolOccurrences = ThreadSafeArray<SymbolOccurrence>()
                DispatchQueue.concurrentPerform(iterations: symbolOccurrences.count) { index in
                    /// Check if the symbol occurence is part of an imported project
                    if !URL(fileURLWithPath: symbolOccurrences[index].location.path).pathComponents.contains(".build") { // IMPORTANT!!!! IF NOT ALL EXTERNAL DEPENDENCIES ARE SCANNED TOO
                        /// Check if the occurence has already been processed once -> if yes ignore it else add it to the occurences that are going to be processed
                        if !symbolOccurrences[index].location.isSystem
                            && !self.binarySearch(alreadyProcessing, key: symbolOccurrences[index]){
                            safeSymbolOccurrences.append(elements: [symbolOccurrences[index]])
                        }
                    }
                }
                /// Append all processed symbol occurences to enhance filtering
                alreadyProcessing.append(contentsOf: safeSymbolOccurrences.value)
                
                
                /// Add all new and filtered occurences to the graph (Insertion in the threadysafe dictionary with usr as key. If duplicated key, then merge occurences :)
                DispatchQueue.concurrentPerform(iterations: safeSymbolOccurrences.value.count) { index in
                    let symbols = toBeNodes.set(occurrence: safeSymbolOccurrences.value[index])
                    
                    /// Check if the symbols that should be added to the queue have already been visited and only add not visited symbols to the queue
                    for symbol in symbols {
                        if !queueMemory.value.contains(where: {(sym: Symbol) -> Bool in sym.usr == symbol.usr && sym.kind == symbol.kind}) {
                            queue.append(elements: [symbol])
                            queueMemory.append(elements: [symbol])
                        }
                    }
                }
                
                /// Add the processed symbol to the visited array
                visited.append(symbol)
            }
        }
        //        print(visited.count)
        //        print(toBeNodes.value.count)
        
        
        self.graph = createGraph(symbolOccurences: [SymbolOccurrence](toBeNodes.values))
    }

    
    private func createGraph(symbolOccurences: [SymbolOccurrence]) -> DependencyGraph<Node> {
        outputMessage(msg: "Creating nodes")
        var graph: DependencyGraph<Node> = DependencyGraph<Node>()
        /// Check filtered symbols
        var relations: ThreadSafeArray<(Symbol,SymbolRelation)> = ThreadSafeArray<(Symbol,SymbolRelation)>()
        var safeNodes: ThreadSafeArray<Node> = ThreadSafeArray<Node>()
        DispatchQueue.concurrentPerform(iterations: symbolOccurences.count) { index in
            let occ: SymbolOccurrence = symbolOccurences[index]
            safeNodes.append(elements: [Node(symbol: occ.symbol, roles: occ.roles)])
            
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
        return graph
    }
    
    private func getSymbolOccurences(symbol: Symbol, indexingServer: IndexingServer) -> [SymbolOccurrence] {
        
        var safeSymbolOccurrences = ThreadSafeArray<SymbolOccurrence>()
        
        DispatchQueue.concurrentPerform(iterations: 2) { index in
            DispatchQueue.concurrentPerform(iterations: nodeRoleCombinations.count) { index in
                let occurences = indexingServer.occurrences(ofUSR: symbol.usr, roles: nodeRoleCombinations[index])
                safeSymbolOccurrences.append(elements: occurences)
            }
            
            DispatchQueue.concurrentPerform(iterations: edgeRoleCombinations.count) { index in
                let occurences = indexingServer.findRelatedSymbols(relatedToUSR: symbol.usr, roles: edgeRoleCombinations[index])
                safeSymbolOccurrences.append(elements: occurences)
            }
        }
        return safeSymbolOccurrences.value
    }
    
    private func binarySearch<T: Comparable>(_ a: [T], key: T) -> Bool {
        var lowerBound = 0
        var upperBound = a.count
        while lowerBound < upperBound {
            let midIndex = lowerBound + (upperBound - lowerBound) / 2
            if a[midIndex] == key {
                return true
            } else if a[midIndex] < key {
                lowerBound = midIndex + 1
            } else {
                upperBound = midIndex
            }
        }
        return false
    }
}
