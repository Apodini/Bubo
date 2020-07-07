//
//  Created by Valentin Hartig on 07.07.20.
//


import Foundation
import SwiftGraph


/// Extension of **SwiftGraph**'s `Edge` class that considers edge roles
public struct RefinedDependencyEdge: Edge, CustomStringConvertible, Equatable {
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

    public func reversed() -> RefinedDependencyEdge {
        return RefinedDependencyEdge(u: v, v: u, directed: directed, roles: roles)
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
    static public func ==(lhs: RefinedDependencyEdge, rhs: RefinedDependencyEdge) -> Bool {
        return lhs.u == rhs.u && lhs.v == rhs.v
    }
}
