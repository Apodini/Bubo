//
//  Created by Valentin Hartig on 23.06.20.
//

import Foundation

extension GraphBuilder {
    
    public func clusterByClasses(graph: DependencyGraph<Node>) -> [DependencyGraph<Node>] {
        return [self.graph]
    }
}
