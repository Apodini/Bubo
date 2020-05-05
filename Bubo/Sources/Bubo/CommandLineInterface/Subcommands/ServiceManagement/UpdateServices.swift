//
//  Created by Valentin Hartig on 21.04.20.
//

import ArgumentParser
import Foundation



// Command to create a new bubo repository
extension Bubo {
    struct UpdateServices: ParsableCommand {
        static let configuration = CommandConfiguration(
            abstract: "Refresh service registration in a projects configuration file",
            discussion: "Tipp: Only use this command when you manually add a new service to the services directory of your project."
            )
        
        @Argument(help: "The name of the project you want to refresh")
        var projectName: String
        
        // Validate Input
        func validate() throws {
            guard projectName.count <= 255 else {
                throw ValidationError("Project name is too long!")
            }
        }
        
        func run() {
            let repositoryManagement = RepositoryManagement()
            if repositoryManagement.refreshServices(projectName: projectName) {
                successMessage(msg: "\(projectName) has been refreshed successfully")
            } else {
                errorMessage(msg: "Updating \(projectName) failed")
            }
        }
    }
}
