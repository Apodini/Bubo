//
//  ListServicesCommand.swift
//  Bubo
//
//  Created by Valentin Hartig on 27/04/20
//  Copyright © 2020 TUM LS1. All rights reserved.
//

import Foundation
import ArgumentParser

// MARK: List
extension Bubo.Service {
    
    /// **Subcommand**:  List all services of a project
    struct List: ParsableCommand {
        static let configuration = CommandConfiguration(
            abstract: "List all services of a specific project")
        
        @OptionGroup()
        var options: Bubo.OptionsPNonly
        
        // Validate Input
        func validate() throws {
                guard options.projectName?.count ?? 0 <= 255 else {
                    throw ValidationError("Project name is too long!")
                }
        }
        
        func run() {
            Main.operationsManager.printServices(projectName: options.projectName)
        }
    }
}
