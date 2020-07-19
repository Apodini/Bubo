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
        for symbol in inQueue {
            queueMemory.insert(element: SymbolHashToken(usr: symbol.usr, kind: symbol.kind))
        }
        
        var filter: ThreadSafeSet<SymbolOccurenceHashToken> = ThreadSafeSet<SymbolOccurenceHashToken>()
        
        var toBeNodes: ThreadSafeDictionary = ThreadSafeDictionary()
        
        outputMessage(msg: "Generating edge and node role permutaions")
        
        /// Modified Breadth-First Search that filters out SymbolOccurences that are in the main packages external depenencies and finds all symbols of the main package (the anlysed service)
        outputMessage(msg: "Querying nodes")
        while !queue.value.isEmpty {
            print(queue.count)
            let symbol = queue.removeFirst()
            /// Check if symbol has already been visited
            let (inserted, memberAfterInsert) = visited.insert(SymbolHashToken(usr: symbol.usr, kind: symbol.kind))
            
            if inserted {
                /// Concurrently get all symbol occurences and related symbol occurences for queue symbol
                let symbolOccurrences = self.getSymbolOccurences(symbol: symbol, indexingServer: indexingServer)
                
                /// Concurrently fIlter all occurences for already visited occurences and location
                DispatchQueue.concurrentPerform(iterations: symbolOccurrences.count) { index in
                    /// Check if the symbol occurence is part of an imported project
                    let occ: SymbolOccurrence = symbolOccurrences[index]
                    
                    /// Create hash token for SymbolOccurence
                    let symHashToken = SymbolOccurenceHashToken(usr: occ.symbol.usr, kind: occ.symbol.kind, roles: occ.roles, path: occ.location.path, isSystem: occ.location.isSystem, line: occ.location.line, utf8Column: occ.location.utf8Column)
                    
                    let (inserted, memberAfterInsert) = filter.insert(element: symHashToken)
                    /// Check if the occurence has already been processed once -> if yes ignore it else add it to the occurences that are going to be processed
                    /// if inserted is false, then the SymbolOccourence is already registered in the filter set
                    if inserted
                        && !URL(fileURLWithPath: occ.location.path).pathComponents.contains(".build")
                        && !occ.location.isSystem
                    {
                        /// Add all new and filtered occurences to the graph (Insertion in the threadsafe dictionary with usr as key. If duplicated key, then merge occurences :)
                        /// Check if the symbols that should be added to the queue have already been visited and only add not visited symbols to the queue
                        for symbol in toBeNodes.set(occurrence: occ) {
                            /// If it's not possible to insert the element, then it already exists
                            let (inserted, memberAfterInsert) = queueMemory.insert(element: SymbolHashToken(usr: symbol.usr, kind: symbol.kind))
                            if inserted {
                                queue.append(elements: [symbol])
                            }
                        }
                    }
                }
            }
        }
        print(toBeNodes.count)
        return toBeNodes
    }
    
    private func getSymbolOccurences(symbol: Symbol, indexingServer: IndexingServer) -> [SymbolOccurrence] {
        var occurences = indexingServer.occurrences(ofUSR: symbol.usr, roles: .all)
        var relatedOccurences = indexingServer.findRelatedSymbols(relatedToUSR: symbol.usr, roles: .all)
        occurences.append(contentsOf: relatedOccurences)
        return occurences
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
