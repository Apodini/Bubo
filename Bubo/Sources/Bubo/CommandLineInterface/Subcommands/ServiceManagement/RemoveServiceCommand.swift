//
//  Created by Valentin Hartig on 28.04.20.
//

import ArgumentParser
import Foundation


extension Bubo.Service {
    
    /// **Subcommand**:  Remove a service from a project
    struct Remove: ParsableCommand {
        static let configuration = CommandConfiguration(
            abstract: "Remove a service from a Bubo project",
            discussion: "Removes a service from Bubo project and deregisters it from the project runtime configuration. Please be careful with this command."
        )
        
        @OptionGroup()
        var options: Bubo.Options
        
        // Validate Input
        func validate() throws {
            if options.projectName != nil {
                let name = options.projectName!
                guard name.count <= 255 else {
                    throw ValidationError("Project name is too long!")
                }
            }
        }
        
        func run() {
            Main.operationsManager.removeService(projectName: options.projectName, serviceName: options.serviceName)
        }
    }
}
