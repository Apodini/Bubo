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
        
       @OptionGroup()
        var options: Bubo.OptionsPNonly
        
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
            let repositoryManagement = ResourceManager()
            repositoryManagement.refreshServices(projectName: options.projectName)
        }
    }
}
