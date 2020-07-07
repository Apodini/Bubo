//
//  Created by Valentin Hartig on 24.06.20.
//

import Foundation
import IndexStoreDB

@dynamicMemberLookup
public struct ThreadSafeDictionary {
    private var wrappedValue: Dictionary<String,SymbolOccurrence>
    private let queue = DispatchQueue(label: "com.Bubo.threadSafeSerialQueue")
    
    init(_ value: Dictionary<String,SymbolOccurrence> = [:]) {
        self.wrappedValue = value
    }
    
    var value: Dictionary<String,SymbolOccurrence> {
        return queue.sync {
            wrappedValue
        }
    }
    
    subscript<T>(dynamicMember keyPath: KeyPath<Dictionary<String,SymbolOccurrence>, T>) -> T {
        queue.sync {
            wrappedValue[keyPath: keyPath]
        }
    }
    
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
