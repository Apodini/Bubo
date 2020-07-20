//
//  Created by Valentin Hartig on 07.07.20.
//

import Foundation


public class GraphSnapshot: Codable, Equatable {
    
///Metrics: [GroupID:MetricValue]
    /// Lack of cohesion of methods
    public var LCOM: [Int:Int]?
    
    /// Fan-In Coupling
    public var FANINCOUPLING: [Int:Int]?
    
    /// Fan-Out Coupling
    public var FANOUTCOUPLING: [Int:Int]?
    
    /// Coupling Between Objects
    public var CBO: [Int:Int]?
    
    
    
    public var timeStamp: String
    
    /// The hash of the commit that was last build
    public var buildGitHash: String
    
    /// The raw dependency graph of the service if it's been generated
    public var graph: DependencyGraph<Node>
    
    
    public init(
        lcom: [Int:Int]? = nil,
        fanIn: [Int:Int]? = nil,
        fanOut: [Int:Int]? = nil,
        cbo: [Int:Int]? = nil,
        timestamp: String,
        buildGitHash: String,
        graph: DependencyGraph<Node>
    ) {
        self.LCOM = lcom
        self.FANINCOUPLING = fanIn
        self.FANOUTCOUPLING = fanOut
        self.CBO = cbo
        
        self.timeStamp = timestamp
        self.buildGitHash = buildGitHash
        self.graph = graph
    }
    
    public static func == (lhs: GraphSnapshot, rhs: GraphSnapshot) -> Bool {
        return lhs.timeStamp == rhs.timeStamp && lhs.buildGitHash == rhs.buildGitHash
    }
}
