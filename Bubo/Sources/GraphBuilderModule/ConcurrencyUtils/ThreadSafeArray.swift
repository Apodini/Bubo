
import Foundation
import IndexStoreDB

@dynamicMemberLookup
struct ThreadSafeArray<Element> {
    private var wrappedValue: Array<Element>
    private let queue = DispatchQueue(label: "com.Bubo.threadSafeSerialQueue")
    
    init(_ value: Array<Element> = []) {
        self.wrappedValue = value
    }
    
    var value: Array<Element> {
        return queue.sync {
            wrappedValue
        }
    }
    
    subscript<T>(dynamicMember keyPath: KeyPath<Array<Element>, T>) -> T {
        queue.sync {
            wrappedValue[keyPath: keyPath]
        }
    }
    
    mutating func append<N: Sequence>(elements: N) where N.Element == Element {
        queue.sync {
            wrappedValue.append(contentsOf: elements)
        }
    }
    
    mutating func removeFirst() -> Element {
        queue.sync {
            return wrappedValue.removeFirst()
        }
    }
    
    mutating func popLast() -> Element? {
        queue.sync {
            return wrappedValue.popLast()
        }
    }
    


}

extension ThreadSafeArray where Element == SymbolOccurrence {
    mutating func sort() -> Void{
        queue.sync {
            wrappedValue.sort()
        }
    }
}

extension ThreadSafeArray where Element == Symbol {
    mutating func sort() -> Void{
        queue.sync {
            wrappedValue.sort()
        }
    }
}
