//
//  Created by Valentin Hartig on 28.04.20.
//

import ArgumentParser
import Foundation



// Command to remove a bubo project
extension Bubo {
    struct Remove: ParsableCommand {
        static let configuration = CommandConfiguration(
            abstract: "Remove a Bubo project.",
            discussion: "Removes a Bubo project and ALL its contents permnently. Please be careful with this command"
        )
        
        @Argument(help: "The name of the Bubo project that should be removed.")
        var projectName: String
        
        // Validate Input
        func validate() throws {
            guard projectName.count <= 255 else {
                throw ValidationError("Project name is too long.")
            }
        }
        
        func run() {
            let fileManagement = FileManagment()
            fileManagement.removeProject(projectName: projectName)
        }
    }
}
