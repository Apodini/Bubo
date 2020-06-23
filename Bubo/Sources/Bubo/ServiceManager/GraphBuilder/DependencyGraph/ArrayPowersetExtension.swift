//
//  Created by Valentin Hartig on 23.06.20.
//
// Source: https://stackoverflow.com/questions/39160552/find-all-combination-of-string-array-in-swift

import Foundation

extension Array {
    var powerset: [[Element]] {
        guard count > 0 else {
            return [[]]
        }

        /// tail contains the whole array BUT the first element
        let tail = Array(self[1..<endIndex])

        /// head contains only the first element
        let head = self[0]

        /// computing the tail's powerset
        let withoutHead = tail.powerset

        /// mergin the head with the tail's powerset
        let withHead = withoutHead.map { $0 + [head] }

        /// returning the tail's powerset and the just computed withHead array
        return withHead + withoutHead
    }
}
