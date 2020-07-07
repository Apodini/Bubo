//
//  Created by Valentin Hartig on 07.07.20.
//

import Foundation
import BuboModelsModule

public class Analyser {
    private var refinedGraph: RefinedDependencyGraph<Node>
    
    
    init(refinedGraph: RefinedDependencyGraph<Node>) {
        self.refinedGraph = refinedGraph
    }
}
