//
//  Created by Valentin Hartig on 27.04.20.
//

import Foundation
import ArgumentParser

extension Bubo {
    struct ListServices: ParsableCommand {
        static let configuration = CommandConfiguration(
            abstract: "List all services of a specific project.")
        
        @Argument(help: "The name of the new bubo project")
        var projectName: String
        
        // Validate Input
        func validate() throws {
            guard projectName.count <= 255 else {
                throw ValidationError("Project name is too long")
            }
        }
        
        func run() {
            let repositoryManagement = RepositoryManagement()
            repositoryManagement.printServices(projectName: projectName)
        }
    }
}
