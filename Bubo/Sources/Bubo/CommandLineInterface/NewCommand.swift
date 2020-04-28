//
//  Created by Valentin Hartig on 21.04.20.
//

import ArgumentParser
import Foundation



// Command to create a new bubo repository
extension Bubo {
    struct New: ParsableCommand {
        static let configuration = CommandConfiguration(
            abstract: "Create a new Bubo Project.")
        
        @Argument(help: "The name of the new bubo project")
        var projectName: String
        
        // Validate Input
        func validate() throws {
            guard projectName.count <= 255 else {
                throw ValidationError("'<name>' is to long")
            }
        }
        
        func run() {
            let fileManagement = FileManagment()
            guard fileManagement.initNewRepo(name: projectName) else {
                errorMessage(msg: "Could not initialise new Projekt \(projectName)")
                return
            }
        }
    }
}
