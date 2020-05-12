//
//  Created by Valentin Hartig on 21.04.20.
//

import ArgumentParser
import Foundation



// Command to create a new bubo repository
extension Bubo.Service {
    struct Refresh: ParsableCommand {
        static let configuration = CommandConfiguration(
            abstract: "Refresh service registration in a projects configuration file",
            discussion: "Tipp: Only use this command when you manually add a new service to the services directory of your project."
            )
        
        @Option(name: [.customShort("n"), .long], help: "The name of the project you want to refresh")
        var projectName: String?
        
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
            repositoryManagement.refreshServices(projectName: projectName)
        }
    }
}
