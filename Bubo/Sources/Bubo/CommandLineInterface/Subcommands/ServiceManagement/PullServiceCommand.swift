//
//  Created by Valentin Hartig on 01.05.20.
//

import Foundation
import ArgumentParser

extension Bubo {
    struct Pull: ParsableCommand {
        static let configuration = CommandConfiguration(
            abstract: "Pull a service of a specific project.")
        
        @Argument(help: "The name of the bubo project.")
        var projectName: String
        
        @Argument(help: "The name of the service to pull.")
        var serviceName: String?
        
        @Flag(help: "Pull all services")
        var all: Bool
        
        // Validate Input
        func validate() throws {
            guard projectName.count <= 255 else {
                throw ValidationError("Project name is too long!")
            }
            
            if serviceName != nil {
                guard serviceName!.count <= 255 else {
                    throw ValidationError("Service name is too long!")
                }
            }
        }
        
        func run() {
            let repositoryManagement = RepositoryManagement()
            
            if all {
                repositoryManagement.pullAllServices(projectName: projectName)
            } else {
                guard serviceName != nil else {
                    errorMessage(msg: "Please specifiy a service you want to pull.")
                    return
                }
                repositoryManagement.pullService(projectName: projectName, serviceName: serviceName!)
            }
        }
    }
}
