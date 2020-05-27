//
//  Created by Valentin Hartig on 12.05.20.
//

import Foundation

class ServiceManager {
    public let resourceManager: ResourceManager;
    public let fileManager: FileManager;
    public let parser: Parser
    public let indexDatabaseConfiguration: IndexDatabaseConfiguration
    public let indexDatabase: IndexDatabase?
    public let indexingServer: IndexingServer?

    init(service: Service) {
        self.resourceManager = ResourceManager()
        self.fileManager = FileManager.default
        self.parser = Parser()
        parser.parse(service: service)
        
        let indexStorePath = service
            .url
            .appendingPathComponent(".build")
            .appendingPathComponent("debug")
            .appendingPathComponent("index")
            .appendingPathComponent("store")
        
        self.indexDatabaseConfiguration = IndexDatabaseConfiguration(indexStorePath: indexStorePath, indexDatabasePath: nil)
        
        do {
            try self.indexDatabase = IndexDatabase(indexDBConfig: self.indexDatabaseConfiguration)
        } catch {
            self.indexDatabase = nil
            errorMessage(msg: "Can't build index database. Has the project been built?")
        }
        guard indexDatabase != nil else {
            errorMessage(msg: "Failed to initialise indexingServer: No indexingDatabase")
            self.indexingServer = nil
            return
        }
        self.indexingServer = IndexingServer(indexDatabase: self.indexDatabase)
    }
    
    public func createDependencyGraph() -> Graph {
        let tokens: [Token] = self.parser.tokens
        let tokenExtensions: [String:Token] = self.parser.tokenExtensions
        
        for <#item#> in <#items#> {
            <#code#>
        }
    }
}
