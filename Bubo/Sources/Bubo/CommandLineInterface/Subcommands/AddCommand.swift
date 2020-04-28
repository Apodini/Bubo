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
    struct AddService: ParsableCommand {
        static let configuration = CommandConfiguration(
            abstract: "Add a new service to an existing Bubo project.")
        @Flag(help: "Initialise new project with passed name if not eexisiting.")
        var new: Bool
        
        @Argument(help: "The name of the Bubo project that the service should be added to.")
        var projectName: String
        
        @Argument(help: "The name of the service that is added.")
        var serviceName: String
        
        @Argument(help: "The URL to the git repository that is added to the project.")
        var gitURL: String
        
        // Validate Input
        func validate() throws {
            guard projectName.count <= 255 else {
                throw ValidationError("Project name is to long")
            }
            
            guard serviceName.count <= 255 else {
                throw ValidationError("Service name is to long")
            }
        }
        
        func run() {
            let repoManagement = RepositoryManagement()
            repoManagement.addGitRepo(projectName: projectName, serviceName: serviceName, gitRepoURL: gitURL, createNewProject: new)
        }
    }
}
