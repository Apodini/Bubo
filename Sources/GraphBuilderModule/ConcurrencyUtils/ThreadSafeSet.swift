//
//  ThreadSafeDictionary.swift
//  Bubo
//
//  Created by Valentin Hartig on 19/07/20
//  Copyright © 2020 TUM LS1. All rights reserved.
//


import Foundation
import IndexStoreDB


// MARK: ThreadSafeSet
/// This is a thread safe generic set implementation
@dynamicMemberLookup
struct ThreadSafeSet<Element> where Element : Hashable {
    
    /// The set of the generic elements
    private var wrappedValue: Set<Element>
    
    /// The dispatch queue that is synchronized
    private let queue = DispatchQueue(label: "com.Bubo.threadSafeSerialQueue")
    
    /// Initialise a set based on an existing set. If no parameter is passed an empty set is created
    init(_ value: Set<Element> = Set<Element>()) {
        self.wrappedValue = value
    }
    
    /// Sync with the dispatch queue and retrive the wrapped set
    var value: Set<Element> {
        return queue.sync {
            wrappedValue
        }
    }
    
    /// Define synced subscript
    subscript<T>(dynamicMember keyPath: KeyPath<Set<Element>, T>) -> T {
        queue.sync {
            wrappedValue[keyPath: keyPath]
        }
    }
    
    /// Sync and then insert the given element in the set if it is not already present.
    /// - parameters:
    ///     - element An element to insert into the set.
    /// - returns: (true, newMember) if newMember was not contained in the set. If an element equal to newMember was already contained in the set, the method returns (false, oldMember), where oldMember is the element that was equal to newMember. In some cases, oldMember may be distinguishable from newMember by identity comparison or some other means.
    mutating func insert(element: Element) -> (inserted: Bool, memberAfterInsert: Element) {
        queue.sync {
            return self.wrappedValue.insert(element)        }
    }
    
    /// Sync then returns a Boolean value that indicates whether the given element exists in the set.
    /// - parameters:
    ///      - element An element to look for in the set.
    /// - returns: true if member exists in the set; otherwise, false.
    mutating func contains(element: Element) -> Bool {
        queue.sync {
            return wrappedValue.contains(element)        }
    }
}
