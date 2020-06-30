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
        var visited: [Symbol] = [Symbol]()
        var queueMemory: ThreadSafeArray<Symbol> = ThreadSafeArray<Symbol>(inQueue) // one half is queue the other half is visited
        var toBeNodes: ThreadSafeDictionary = ThreadSafeDictionary()
        
        /// Modified Breadth-First Search that filters out SymbolOccurences that are in the main packages external depenencies and finds all symbols of the main package (the anlysed service)
        outputMessage(msg: "Querying nodes")
        while !queue.value.isEmpty {
            print("Queue length: \(queue.value.count)")
            let symbol = queue.removeFirst()
            /// Check if symbol has already been visited
            if !visited.contains(where: {(sym: Symbol) -> Bool in sym.usr == symbol.usr && sym.kind == symbol.kind}) {
                
                /// Concurrently get all symbol occurences and related symbol occurences for queue symbol
                let symbolOccurrences = self.getSymbolOccurences(symbol: symbol, indexingServer: indexingServer)
                
                /// Sort alreadyProcessing array to optimise binary search
                
                /// Concurrently fIlter all occurences for already visited occurences and location
                var safeSymbolOccurrences = ThreadSafeArray<SymbolOccurrence>()
                DispatchQueue.concurrentPerform(iterations: symbolOccurrences.count) { index in
                    /// Check if the symbol occurence is part of an imported project
                    if !URL(fileURLWithPath: symbolOccurrences[index].location.path).pathComponents.contains(".build") { // IMPORTANT!!!! IF NOT ALL EXTERNAL DEPENDENCIES ARE SCANNED TOO
                        /// Check if the occurence has already been processed once -> if yes ignore it else add it to the occurences that are going to be processed
                        if !symbolOccurrences[index].location.isSystem {
                            safeSymbolOccurrences.append(elements: [symbolOccurrences[index]])
                        }
                    }
                }
                /// Append all processed symbol occurences to enhance filtering
                
                
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
}
