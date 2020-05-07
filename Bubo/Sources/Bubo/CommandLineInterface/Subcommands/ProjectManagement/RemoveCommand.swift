//
//  Created by Valentin Hartig on 28.04.20.
//

import ArgumentParser
import Foundation



// Command to remove a bubo project
extension Bubo {
    struct Remove: ParsableCommand {
        static let configuration = CommandConfiguration(
            abstract: "Remove a Bubo project",
            discussion: "Removes a Bubo project and ALL its contents permanently. Please be careful with this command"
        )
        
        @Argument(help: "The name of the Bubo project that should be removed")
        var projectName: String?
        
        @Flag(help: "Remove the procject permanently from disk (not recommended)")
        var permanently: Bool
        
        func validate() throws {
            if projectName != nil {
                let name = projectName!
                guard name.count <= 255 else {
                    throw ValidationError("Project name is too long!")
                }
            }
        }
        
        func run() {
            let fileManagement = FileManagement()
            if permanently {
                fileManagement.removeProject(projectName: projectName)
            } else {
                fileManagement.deregisterProject(projectName: projectName)
            }
        }
    }
}
