//
//  Created by Valentin Hartig on 07.07.20.
//

import Foundation


public class GraphSnapshot: Codable, Equatable {
    
///Metrics: [GroupID:MetricValue] MetricValue is between 0 and 100 to represent the interval [0,1]
    /// Lack of cohesion of methods <groupID,LCOMValue>
    public var LCOM: [Int:Int]?
    
    /// Response for a class <groupID,RFCValue>
    public var RFC: [Int:Int]?
    
    /// Coupling Between Objects <groupID,CBOValue>
    public var CBO: [Int:Int]?
    
    
    /// Timestamp for the creation of the graph snapshot
    public var timeStamp: String
    
    /// The hash of the commit that was last build
    public var buildGitHash: String
    
    /// The raw dependency graph of the service
    public var graph: DependencyGraph<Node>
    
    
    public init(
        lcom: [Int:Int]? = nil,
        rfc: [Int:Int]? = nil,
        cbo: [Int:Int]? = nil,
        timestamp: String,
        buildGitHash: String,
        graph: DependencyGraph<Node>
    ) {
        self.LCOM = lcom
        self.RFC = rfc
        self.CBO = cbo
        
        self.timeStamp = timestamp
        self.buildGitHash = buildGitHash
        self.graph = graph
    }
    
    public static func == (lhs: GraphSnapshot, rhs: GraphSnapshot) -> Bool {
        return lhs.timeStamp == rhs.timeStamp && lhs.buildGitHash == rhs.buildGitHash
    }
}
