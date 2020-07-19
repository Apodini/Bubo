//
//  Created by Valentin Hartig on 19.07.20.
//
import Foundation
import IndexStoreDB

@dynamicMemberLookup
struct ThreadSafeSet<Element> where Element : Hashable {
    private var wrappedValue: Set<Element>
    private let queue = DispatchQueue(label: "com.Bubo.threadSafeSerialQueue")
    
    init(_ value: Set<Element> = Set<Element>()) {
        self.wrappedValue = value
    }
    
    var value: Set<Element> {
        return queue.sync {
            wrappedValue
        }
    }
    
    
    
    subscript<T>(dynamicMember keyPath: KeyPath<Set<Element>, T>) -> T {
        queue.sync {
            wrappedValue[keyPath: keyPath]
        }
    }
    
    mutating func insert(element: Element) -> (inserted: Bool, memberAfterInsert: Element) {
        queue.sync {
            return self.wrappedValue.insert(element)        }
    }
    
    mutating func contains(element: Element) -> Bool {
        queue.sync {
            return wrappedValue.contains(element)        }
    }
}
