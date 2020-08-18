//
//  DependencyEdge.swift
//  Bubo
//
//  Created by Valentin Hartig on 17/05/20
//  Copyright © 2020 TUM LS1. All rights reserved.
//


import Foundation
import SwiftGraph


// MARK: DependencyEdge: Edge, CustomStringConvertible, Equatable
/// Extension of **SwiftGraph**'s `Edge` class that considers Edge roles
public struct DependencyEdge: Edge, CustomStringConvertible, Equatable {
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

    public func reversed() -> DependencyEdge {
        return DependencyEdge(u: v, v: u, directed: directed, roles: roles)
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
    static public func ==(lhs: DependencyEdge, rhs: DependencyEdge) -> Bool {
        return lhs.u == rhs.u && lhs.v == rhs.v
    }
}


