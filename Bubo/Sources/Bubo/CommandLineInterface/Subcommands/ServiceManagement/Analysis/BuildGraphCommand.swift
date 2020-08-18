//
//  BuildGraphCommand.swift
//  Bubo
//
//  Created by Valentin Hartig on 17/05/20
//  Copyright © 2020 TUM LS1. All rights reserved.
//


import Foundation
import ArgumentParser
import ServiceAnalyserModule


// MARK: - Graph
extension Bubo.Service.Analyse {
    
    /// **Subcommand**: Subcommand to generate a dependency graph and save it to a .dot file
    struct Graph: ParsableCommand {
        static let configuration = CommandConfiguration(
            abstract: "Generates a graph for a given service",
            discussion: "The program only generates a graph for each indiviudal commit.")
        
        @OptionGroup()
        var options: Bubo.Options
        
        // Validate Input
        func validate() throws {
            if options.projectName != nil {
                let name = options.projectName!
                guard name.count <= 255 else {
                    throw ValidationError("Project name is too long!")
                }
            }
            
            guard options.serviceName.count <= 255 else {
                    throw ValidationError("Service name is too long!")
                }
        }
        
        func run() {
            Main.operationsManager.buildGraph(projectName: options.projectName, serviceName: options.serviceName)
        }
    }
}
