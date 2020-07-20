//
//  Created by Valentin Hartig on 13.07.20.
//

import Foundation
import GraphBuilderModule
import ResourceManagerModule

extension StructuralAnalyser {
    public func createDependencyGraph() -> DependencyGraph<Node>? {
        // Build service
        headerMessage(msg: "Checking Graph")
        self.mostRecentGraphSnapshot = resourceManager.getMostRecentGraphSnapshot(service: service)
        
        var fileURLs: [URL] = [URL]()
        for file in service.files {
            fileURLs.append(file.fileURL)
        }
        
        if !self.compareGitHash() || mostRecentGraphSnapshot == nil{
            outputMessage(msg: "Graph needs to be updated")
            self.cleanUpService()
            self.buildService()
            
            // Init graph builder service
            self.graphBuilder = GraphBuilder(packageRoot: service.gitRootURL, fileURLs: fileURLs)
            
            self.graphBuilder!.generateRefinedDependencyGraph()
            self.updateGraph()
            successMessage(msg: "Graph successfully updated!")
            return self.graphBuilder!.graph
        } else {
            successMessage(msg: "Graph is up to date!")
            self.graphBuilder = GraphBuilder(packageRoot: service.gitRootURL, fileURLs: fileURLs)
            self.graphBuilder?.graph = mostRecentGraphSnapshot!.graph
            return mostRecentGraphSnapshot!.graph
        }
    }
    
    public func compareGitHash() -> Bool {
        
        guard let snapshot = mostRecentGraphSnapshot else {
            return false
        }
        
        return service.currentGitHash == snapshot.buildGitHash
    }
}
