/// Source: PeckerKit

import Foundation

final class ThreadSafe<A> {
    private var _value: A
    private let queue = DispatchQueue(label: "com.Bubo.threadSafeSerialQueue")

    init(_ value: A) {
        self._value = value
    }

    var value: A {
        return queue.sync { _value }
    }

    func atomically(_ transform: (inout A) -> ()) {
        queue.sync {
            transform(&self._value)
        }
    }
}
