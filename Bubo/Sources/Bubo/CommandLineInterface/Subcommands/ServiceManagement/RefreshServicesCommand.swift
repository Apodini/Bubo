//
//  RefreshServicesCommand.swift
//  Bubo
//
//  Created by Valentin Hartig on 21/04/20
//  Copyright © 2020 TUM LS1. All rights reserved.
//

import ArgumentParser
import Foundation


// MARK: - Refresh
extension Bubo.Service {
    
    /// **Subcommand**: Refresh the service registrations of a project (Update all service configurations) 
    struct Refresh: ParsableCommand {
        static let configuration = CommandConfiguration(
            abstract: "Refresh service registration in a projects configuration file",
            discussion: "Tipp: Only use this command when you manually add a new service to the services directory of your project."
            )
        
       @OptionGroup()
        var options: Bubo.OptionsPNonly
        
        // Validate Input
        func validate() throws {
            if options.projectName != nil {
                let name = options.projectName!
                guard name.count <= 255 else {
                    throw ValidationError("Project name is too long!")
                }
            }
        }
        
        func run() {
            Main.operationsManager.refreshServices(projectName: options.projectName)
        }
    }
}
