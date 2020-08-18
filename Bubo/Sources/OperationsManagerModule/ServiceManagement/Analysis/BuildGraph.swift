//
//  BuildGraph.swift
//  Bubo
//
//  Created by Valentin Hartig on 19/07/20
//  Copyright © 2020 TUM LS1. All rights reserved.
//


import Foundation
import ResourceManagerModule
import ServiceAnalyserModule


// MARK: OperationsManager
extension OperationsManager {
    
    /// Build the dependency graph for a given project and service
    /// - parameters:
    ///     - projectName The name of the project, if nil the current directory is checked if it is a project
    ///     - serviceName The name of the service for which the graph should be built
    public func buildGraph(projectName: String?, serviceName: String) -> Void {
        /// Get the `projecHandle` and the project configuration `projectConfig`
        guard var (projectHandle, projectConfig) = self.resourceManager.decodeProjectConfig(pName: projectName) else {
            abortMessage(msg: "Building Graph for \(serviceName)")
            return
        }
        
        /// Fetch service configuration
        guard let (_,serviceConfig) = self.resourceManager.decodeServiceConfig(pName: projectName, serviceName: serviceName) else {
            abortMessage(msg: "Building Graph for \(serviceName)")
            return
        }
        
        let serviceManager = ServiceManager(service: serviceConfig, pName: projectHandle)
        guard serviceManager.structuralAnalyser.createDependencyGraph() != nil else {
            return
        }
    }

}
