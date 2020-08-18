//
//  ThreadSafeDictionary.swift
//  Bubo
//
//  Created by Valentin Hartig on 24/06/20
//  Copyright © 2020 TUM LS1. All rights reserved.
//


import Foundation
import IndexStoreDB


// MARK: ThreadSafeDictionary
/// This is a thread safe <string,SymbolOccurence> Dictionary  implementation
@dynamicMemberLookup
public struct ThreadSafeDictionary {
    
    /// The dictionary of the <string,SymbolOccurence> elements
    private var wrappedValue: Dictionary<String,SymbolOccurrence>
    
    /// The dispatch queue that is synchronized
    private let queue = DispatchQueue(label: "com.Bubo.threadSafeSerialQueue")
    
    init(_ value: Dictionary<String,SymbolOccurrence> = [:]) {
        self.wrappedValue = value
    }
    
    /// Sync with the dispatch queue and retrive the wrapped dictionary
    var value: Dictionary<String,SymbolOccurrence> {
        return queue.sync {
            wrappedValue
        }
    }
    
    /// Define synced subscript
    subscript<T>(dynamicMember keyPath: KeyPath<Dictionary<String,SymbolOccurrence>, T>) -> T {
        queue.sync {
            wrappedValue[keyPath: keyPath]
        }
    }
    
    /// Insert a new key value pair to the dictionary
    /// - note: If an element for the key already exists, the SymbolOccurences for the keys are merged and the location is the current one or, if the other one is the definition of the Symbol, its location
    /// - returns: All Symbols in the relations of the inserted SymboOccurence
    mutating func set(occurrence: SymbolOccurrence) -> [Symbol] {
        queue.sync {
            var queue: [Symbol] = [Symbol]()
            if !wrappedValue.keys.contains(occurrence.symbol.usr) {
                wrappedValue[occurrence.symbol.usr] = occurrence
                queue.append(occurrence.symbol)
                for relation in occurrence.relations {
                    queue.append(relation.symbol)
                }
            } else {
                if var duplicate = wrappedValue.removeValue(forKey: occurrence.symbol.usr) {
                    duplicate.roles.formUnion(occurrence.roles)
                    if occurrence.roles.contains(.definition) {
                        duplicate.location = occurrence.location
                    }
                    for relation in occurrence.relations {
                        if !duplicate.relations.contains(relation) {
                            duplicate.relations.append(relation)
                        }
                        queue.append(relation.symbol)
                    }
                    wrappedValue[duplicate.symbol.usr] = duplicate
                }
            }
            return queue
        }
    }
}
