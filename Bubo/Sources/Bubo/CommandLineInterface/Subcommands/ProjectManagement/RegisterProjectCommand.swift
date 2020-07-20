//
//  File.swift
//  
//
//  Created by Valentin Hartig on 20.07.20.
//
import ArgumentParser
import Foundation
import ResourceManagerModule


extension Bubo {
    
    /// **Subcommand**:  Remove a project from the registerd projects
    struct Register: ParsableCommand {
        static let configuration = CommandConfiguration(
            abstract: "Register an existing project",
            discussion: "Registers an existing project in the root configuration. To register a project you need to be in the projects directory. The program does NOT check the validity of the configuration files!"
        )
        
        func run() {
            Main.operationsManager.registerProject()
        }
    }
}
