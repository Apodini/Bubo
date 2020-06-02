//
//  Created by Valentin Hartig on 12.05.20.
//

import Foundation

class ServiceManager {
    private let resourceManager: ResourceManager;
    private let fileManager: FileManager;
    public let parser: Parser
    private let graphBuilder: GraphBuilder


    init(service: Service) {
        self.resourceManager = ResourceManager()
        self.fileManager = FileManager.default
        self.parser = Parser()
        parser.parse(service: service)
        self.graphBuilder = GraphBuilder(tokens: parser.tokens, service: service)
        
    }
    
    public func createDependencyGraph() -> DependencyGraph<Node>? {
        graphBuilder.createDependencyGraph()
        return graphBuilder.graph
    }
}
