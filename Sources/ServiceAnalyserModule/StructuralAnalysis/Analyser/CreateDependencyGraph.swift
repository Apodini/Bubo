//
//  CreateDependencyGraph.swift
//  Bubo
//
//  Created by Valentin Hartig on 06/05/20
//  Copyright © 2020 TUM LS1. All rights reserved.
//


import Foundation
import GraphBuilderModule
import ResourceManagerModule


// MARK: StructuralAnalyser
extension StructuralAnalyser {
    
    /// Checks if the currently available data of a service and initiates a new graphsnapshot when data is not up to date. If Data is not up to date, the services indexingdata is pruged and the service is rebuild
    /// - returns: The built dependency graph for  a service or nil if an error occured
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
    
    /// Compare the current git commit hash with the git commit hash of the most recent graohSnapshot
    public func compareGitHash() -> Bool {
        
        guard let snapshot = mostRecentGraphSnapshot else {
            return false
        }
        
        return service.currentGitHash == snapshot.buildGitHash
    }
}
