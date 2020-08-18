//
//  NewProjectCommand.swift
//  Bubo
//
//  Created by Valentin Hartig on 21/04/20
//  Copyright © 2020 TUM LS1. All rights reserved.
//


import ArgumentParser
import Foundation
import ResourceManagerModule

// MARK: - New
extension Bubo {
    
    /// **Subcommand**:  Create a new project
    struct New: ParsableCommand {
        static let configuration = CommandConfiguration(
            abstract: "Create a new Bubo project",
            discussion: "Creates a new Bubo project in the current directory. The default project name is the name of the current directory. To speecify a dedicated projeect name use the corresponding option" )
        
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
            Main.operationsManager.newProject(pName: options.projectName)
        }
    }
}
