//
//  File.swift
//  
//
//  Created by Valentin Hartig on 27.04.20.
//

import Foundation
import ArgumentParser

// Command to create a new bubo repository
extension Bubo {
    struct Add: ParsableCommand {
        static let configuration = CommandConfiguration(
            abstract: "Add a new service to an existing Bubo project.")
        
        @Argument(help: "The name of the Bubo project that the service should be added to")
        var projectName: String
        
        @Argument(help: "The URL to the git repository that is added to the project")
        var gitURL: String
        
        // Validate Input
        func validate() throws {
            guard projectName.count <= 255 else {
                throw ValidationError("'<name>' is to long")
            }
        }
        
        func run() {
            let repoManagement = RepositoryManagement()
            
        }
    }
}
