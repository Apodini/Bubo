//
//  StructuralAnalyser.swift
//  Bubo
//
//  Created by Valentin Hartig on 07/07/20
//  Copyright © 2020 TUM LS1. All rights reserved.
//


import Foundation
import ShellOut
import GraphBuilderModule
import ResourceManagerModule


// MARK: StructuralAnalyser
public class StructuralAnalyser {
    
    /// Provide FileManager for all operations
    public let fileManager: FileManager  = FileManager.default
    
    /// GraphBuilder that creates a dependency graph for the intermediate representation
    public var graphBuilder: GraphBuilder?
    
    /// The service that is analysed by the structural analyser
    public var service: ServiceConfiguration
    
    /// The most recent graph snapshot of the analysed service
    public var mostRecentGraphSnapshot: GraphSnapshot?
    
    /// The name of the project the service belongs to
    public let projectName: String
    
    /// Provide a Resource Manager for all operations
    public let resourceManager: ResourceManager = ResourceManager()
    
    
    public init(service: ServiceConfiguration, pName: String) {
        // Init properties
        self.service = service
        self.mostRecentGraphSnapshot = nil
        self.graphBuilder = nil
        self.projectName = pName
    }
}
