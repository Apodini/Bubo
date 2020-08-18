//
//  AddCommand.swift
//  Bubo
//
//  Created by Valentin Hartig on 27/04/20
//  Copyright © 2020 TUM LS1. All rights reserved.
//

import Foundation
import ArgumentParser

// MARK: - Add
extension Bubo.Service {
    
    /// **Subcommand**: Add a new service to a project
    struct Add: ParsableCommand {
        static let configuration = CommandConfiguration(
            abstract: "Add a new service to an existing Bubo project")
        
        @OptionGroup()
        var options: Bubo.Options
        
        @Argument(help: "The URL to the git repository that is added to the project")
        var gitURL: String
        
        // Validate Input
        func validate() throws {
            if options.projectName != nil {
                guard options.projectName!.count <= 255 else {
                    throw ValidationError("Project name is to long")
                }
            }
            
            guard options.serviceName.count <= 255 else {
                throw ValidationError("Service name is to long")
            }
        }
        
        func run() {
            Main.operationsManager.addService(projectName: options.projectName, serviceName: options.serviceName, gitRepoURL: gitURL)
        }
    }
}
