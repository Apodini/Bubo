//
//  Created by Valentin Hartig on 28.04.20.
//

import ArgumentParser
import Foundation



// Command to remove a service from a Bubo project
extension Bubo.Service {
    struct Remove: ParsableCommand {
        static let configuration = CommandConfiguration(
            abstract: "Remove a service from a Bubo project",
            discussion: "Removes a service from Bubo project and deregisters it from the project runtime configuration. Please be careful with this command."
        )
        
        @Option(name: [.customShort("n"), .long], help: "The name of the Bubo project")
        var projectName: String?
        
        @Argument(help: "The name of the service living inside the Bubo project")
        var ServiceName: String
        
        // Validate Input
        func validate() throws {
            if projectName != nil {
                let name = projectName!
                guard name.count <= 255 else {
                    throw ValidationError("Project name is too long!")
                }
            }
        }
        
        func run() {
            let repositoryManagement = ResourceManager()
            repositoryManagement.removeService(projectName: projectName, serviceName: ServiceName)
        }
    }
}
