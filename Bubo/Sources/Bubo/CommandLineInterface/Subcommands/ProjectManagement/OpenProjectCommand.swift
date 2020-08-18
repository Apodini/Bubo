
//
//  OpenProjectsCommand.swift
//  Bubo
//
//  Created by Valentin Hartig on 01/04/20
//  Copyright © 2020 TUM LS1. All rights reserved.
//

import Foundation
import ArgumentParser
import ResourceManagerModule

// MARK: - Open
extension Bubo {
    
    /// **Subcommand**:  Open a project in the finder
    struct Open: ParsableCommand {
        static let configuration = CommandConfiguration(
            abstract: "Opens a specific project in the finder")
        
        @OptionGroup()
        var options: Bubo.OptionsPNonly
        
        func validate() throws {
            if options.projectName != nil {
                let name = options.projectName!
                guard name.count <= 255 else {
                    throw ValidationError("Project name is too long!")
                }
            }
        }
        
        func run() {
            Main.operationsManager.openProject(pName: options.projectName)
        }
    }
}

