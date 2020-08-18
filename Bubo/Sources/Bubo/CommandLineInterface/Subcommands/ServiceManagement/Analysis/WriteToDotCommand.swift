//
//  WriteToDotCommand.swift
//  Bubo
//
//  Created by Valentin Hartig on 20/07/20
//  Copyright © 2020 TUM LS1. All rights reserved.
//


import Foundation
import ArgumentParser
import ServiceAnalyserModule


extension Bubo.Service.Analyse {
    
    /// **Subcommand**: Subcommand to generate a dependency graph and save it to a .dot file
    struct Dot: ParsableCommand {
        static let configuration = CommandConfiguration(
            abstract: "Parses all files of a service and outputs the graph as a .dot file",
            discussion: "Warning: Large programs generate really large graphs.")
        
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
            Main.operationsManager.writeToDot(projectName: options.projectName, serviceName: options.serviceName)
        }
    }
}

