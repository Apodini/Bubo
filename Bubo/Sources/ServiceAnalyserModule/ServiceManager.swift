//
//  ServiceManager.swift
//  Bubo
//
//  Created by Valentin Hartig on 12/05/20
//  Copyright © 2020 TUM LS1. All rights reserved.
//


import Foundation
import ShellOut
import ResourceManagerModule


// MARK: ServiceManager
/// This class is a facade for all the different analysers of Bubo
public class ServiceManager {
    
    /// Provide FileManager for all operations
    public let fileManager: FileManager  = FileManager.default
    
    /// The service that is analysed by the  analysers
    private var service: ServiceConfiguration
    
    /// The name of the project the service belongs to
    private var projectName: String
    
    /// Provide a Resource Manager for all operations
    private let resourceManager: ResourceManager = ResourceManager()
    
    /// The structural analyser to run structural analysis metrics
    public var structuralAnalyser: StructuralAnalyser
    
    
    public init(service: ServiceConfiguration, pName: String?) {
        // Init properties
        self.service = service
        guard let name = pName else {
            errorMessage(msg: "Can't unwrap project name!")
            self.projectName = ""
            self.structuralAnalyser = StructuralAnalyser(service: service, pName: "")
            return
        }
        self.projectName = name
        self.structuralAnalyser = StructuralAnalyser(service: service, pName: name)
    }
    
}
