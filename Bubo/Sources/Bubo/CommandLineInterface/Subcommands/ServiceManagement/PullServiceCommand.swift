//
//  PullServiceCommand.swift
//  Bubo
//
//  Created by Valentin Hartig on 01/05/20
//  Copyright © 2020 TUM LS1. All rights reserved.
//

import Foundation
import ArgumentParser

// MARK: - Pull
extension Bubo.Service {
    
    /// **Subcommand**:  Pull one or multiple services for a project
    struct Pull: ParsableCommand {
        static let configuration = CommandConfiguration(
            abstract: "Pull a service of a specific project")
        
        @OptionGroup()
        var options: Bubo.Options
        
        @Flag(help: "Pull all services")
        var all: Bool
        
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
            
            if all {
                Main.operationsManager.pullAllServices(projectName: options.projectName)
            } else {
                Main.operationsManager.pullService(projectName: options.projectName, serviceName: options.serviceName)
            }
        }
    }
}
