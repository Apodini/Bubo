//
//  Created by Valentin Hartig on 01.05.20.
//

import Foundation
import ArgumentParser


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
            let repositoryManagement = ResourceManager()
            
            if all {
                repositoryManagement.pullAllServices(projectName: options.projectName)
            } else {
                guard options.serviceName != nil else {
                    errorMessage(msg: "Please specifiy a service you want to pull")
                    return
                }
                repositoryManagement.pullService(projectName: options.projectName, serviceName: options.serviceName)
            }
        }
    }
}
