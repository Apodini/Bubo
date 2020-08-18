//
//  ThreadSafeArray.swift
//  Bubo
//
//  Created by Valentin Hartig on 20/06/20
//  Copyright © 2020 TUM LS1. All rights reserved.
//


import Foundation
import IndexStoreDB


// MARK: ThreadSafeArray
/// This is a thread safe generic array implementation
@dynamicMemberLookup
struct ThreadSafeArray<Element> {
    
    /// The array of the generic elements
    private var wrappedValue: Array<Element>
    
    /// The dispatch queue that is synchronized
    private let queue = DispatchQueue(label: "com.Bubo.threadSafeSerialQueue")
    
    /// Initialise an array based on an existing collection. If no parameter is passed an empty array is created
    init(_ value: Array<Element> = []) {
        self.wrappedValue = value
    }
    
    /// Sync with the dispatch queue and retrive the wrapped array
    var value: Array<Element> {
        return queue.sync {
            wrappedValue
        }
    }
    
    /// Define synced subscript
    subscript<T>(dynamicMember keyPath: KeyPath<Array<Element>, T>) -> T {
        queue.sync {
            wrappedValue[keyPath: keyPath]
        }
    }
    
    /// Sync then adds the elements of a sequence or collection to the end of this collection.
    /// - parameters:
    ///     - elements The elements to append to the collection.
    mutating func append<N: Sequence>(elements: N) where N.Element == Element {
        queue.sync {
            wrappedValue.append(contentsOf: elements)
        }
    }
    
    /// Sync then removes and return the first element of the collection.
    /// - returns: The removed element.
    mutating func removeFirst() -> Element {
        queue.sync {
            return wrappedValue.removeFirst()
        }
    }
    
    /// Sync then removes and return the last element of the collection.
    /// - returns: The last element of the collection if the collection is not empty; otherwise, nil.
    mutating func popLast() -> Element? {
        queue.sync {
            return wrappedValue.popLast()
        }
    }
}

// MARK: ThreadSafeArray where Element == SymbolOccurrence
extension ThreadSafeArray where Element == SymbolOccurrence {
    
    /// Sorts the SymbolOccurrence collection in place.
    mutating func sort() -> Void{
        queue.sync {
            wrappedValue.sort()
        }
    }
}

// MARK: ThreadSafeArray where Element == Symbol
extension ThreadSafeArray where Element == Symbol {
    
    /// Sorts the Symbol collection in place.
    mutating func sort() -> Void{
        queue.sync {
            wrappedValue.sort()
        }
    }
}
