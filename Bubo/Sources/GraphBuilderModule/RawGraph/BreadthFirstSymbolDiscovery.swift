//
//  Created by Valentin Hartig on 30.06.20.
//

import Foundation
import IndexStoreDB

extension GraphBuilder {
    
    /// - note: Filtering already visited nodes leads to a very steep performance drop. It's somehow faster to process everything over and over again
    /// - note: It's not possible to use hashing, because IndexStoreDBs Symbols and SymbolOccurences can't conform to `Hashable`
    
    public func breadthFirstSymbolDiscovery(inQueue: [Symbol], indexingServer: IndexingServer) -> ThreadSafeDictionary {
        
        var queue: ThreadSafeArray<Symbol> = ThreadSafeArray<Symbol>(inQueue)
        var visited: Set<SymbolHashToken> = Set<SymbolHashToken>()
        
        /// Init queueMemory and add all symbols that are in the queue
        var queueMemory: ThreadSafeSet<SymbolHashToken> = ThreadSafeSet<SymbolHashToken>() // one half is queue the other half is visited
        DispatchQueue.concurrentPerform(iterations: inQueue.count) { index in
            queueMemory.insert(element: SymbolHashToken(usr: inQueue[index].usr, kind: inQueue[index].kind))
        }
        
        var filter: ThreadSafeSet<SymbolOccurenceHashToken> = ThreadSafeSet<SymbolOccurenceHashToken>()
        var toBeNodes: ThreadSafeDictionary = ThreadSafeDictionary()
        
        outputMessage(msg: "Generating edge and node role permutaions")
        self.nodeRoleCombinations = NodeRole.getAllRoleCombinations()
        self.edgeRoleCombinations = EdgeRole.getAllRoleCombinations()
        
        /// Modified Breadth-First Search that filters out SymbolOccurences that are in the main packages external depenencies and finds all symbols of the main package (the anlysed service)
        outputMessage(msg: "Querying nodes")
        while !queue.value.isEmpty {
            print(queue.count)
            let symbol = queue.removeFirst()
            /// Check if symbol has already been visited
            let symHash = SymbolHashToken(usr: symbol.usr, kind: symbol.kind)
            if !visited.contains(symHash) {
                
                /// Concurrently get all symbol occurences and related symbol occurences for queue symbol
                let symbolOccurrences = self.getSymbolOccurences(symbol: symbol, indexingServer: indexingServer)
                                
                /// Concurrently fIlter all occurences for already visited occurences and location
                var safeSymbolOccurrences = ThreadSafeArray<SymbolOccurrence>()
                DispatchQueue.concurrentPerform(iterations: symbolOccurrences.count) { index in
                    /// Check if the symbol occurence is part of an imported project
                    let occ: SymbolOccurrence = symbolOccurrences[index]
                    
                    let symHashToken = SymbolOccurenceHashToken(usr: occ.symbol.usr, kind: occ.symbol.kind, roles: occ.roles, path: occ.location.path, isSystem: occ.location.isSystem, line: occ.location.line, utf8Column: occ.location.utf8Column)
                    
                    if !filter.contains(element: symHashToken) && !URL(fileURLWithPath: occ.location.path).pathComponents.contains(".build") { // IMPORTANT!!!! IF NOT ALL EXTERNAL DEPENDENCIES ARE SCANNED TOO
                        /// Check if the occurence has already been processed once -> if yes ignore it else add it to the occurences that are going to be processed
                        if !occ.location.isSystem {
                            safeSymbolOccurrences.append(elements: [occ])
                        }
                    }
                    filter.insert(element: symHashToken)
                }
                
                /// Add all new and filtered occurences to the graph (Insertion in the threadysafe dictionary with usr as key. If duplicated key, then merge occurences :)
                DispatchQueue.concurrentPerform(iterations: safeSymbolOccurrences.value.count) { index in
                    let symbols = toBeNodes.set(occurrence: safeSymbolOccurrences.value[index])
                    
                    /// Check if the symbols that should be added to the queue have already been visited and only add not visited symbols to the queue
                    for symbol in symbols {
                        let currSymHash = SymbolHashToken(usr: symbol.usr, kind: symbol.kind)
                        if !queueMemory.contains(element: currSymHash) {
                            queue.append(elements: [symbol])
                            queueMemory.insert(element: currSymHash)
                        }
                    }
                }
                
                /// Add the processed symbol to the visited set
                visited.insert(symHash)
            }
        }
        //        print(visited.count)
        //        print(toBeNodes.value.count)
        
        print(toBeNodes.count)
        return toBeNodes
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
    
    private struct SymbolOccurenceHashToken: Hashable {
        var usr: String
        var kind: IndexSymbolKind
        var roles: SymbolRole
        var path: String
        var isSystem: Bool
        var line: Int
        var utf8Column: Int
        
        init(usr: String, kind: IndexSymbolKind, roles: SymbolRole, path: String, isSystem: Bool, line: Int, utf8Column: Int) {
            self.usr = usr
            self.kind = kind
            self.roles = roles
            self.path = path
            self.isSystem = isSystem
            self.line = line
            self.utf8Column = utf8Column
        }
    }
    
    private struct SymbolHashToken: Hashable {
        var usr: String
        var kind: IndexSymbolKind
        
        init(usr: String, kind: IndexSymbolKind) {
            self.usr = usr
            self.kind = kind
        }
    }
}
