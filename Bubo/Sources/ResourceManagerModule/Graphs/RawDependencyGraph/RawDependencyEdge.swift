//
//  Created by Valentin Hartig on 01.06.20.
//

import Foundation
import SwiftGraph


/// Extension of **SwiftGraph**'s `Edge` class that considers Edge roles
public struct RawDependencyEdge: Edge, CustomStringConvertible, Equatable {
    public var u: Int
    public var v: Int
    public var directed: Bool
    public var roles: [EdgeRole]
    
    public init(u: Int, v: Int, directed: Bool, roles: [EdgeRole]) {
        self.u = u
        self.v = v
        self.directed = directed
        self.roles = roles
    }

    public func reversed() -> RawDependencyEdge {
        return RawDependencyEdge(u: v, v: u, directed: directed, roles: roles)
    }

    /// Implement `CustomStringConvertible` protocol
    public var description: String {
        var roles = ""
        for role in roles {
            roles += "|\(role)|"
        }
        return "\(u) -\(roles)-> \(v)"
    }

    // MARK: Operator Overloads
    static public func ==(lhs: RawDependencyEdge, rhs: RawDependencyEdge) -> Bool {
        return lhs.u == rhs.u && lhs.v == rhs.v
    }
}


