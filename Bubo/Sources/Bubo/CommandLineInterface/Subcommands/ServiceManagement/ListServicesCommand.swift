//
//  Created by Valentin Hartig on 27.04.20.
//

import Foundation
import ArgumentParser

extension Bubo.Service {
    struct List: ParsableCommand {
        static let configuration = CommandConfiguration(
            abstract: "List all services of a specific project")
        
        @Option(name: [.customShort("n"), .long], help: "The name of the new bubo project")
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
            let repositoryManagement = RepositoryManagement()
            repositoryManagement.printServices(projectName: projectName)
        }
    }
}
