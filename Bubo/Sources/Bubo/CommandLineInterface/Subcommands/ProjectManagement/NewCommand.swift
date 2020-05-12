//
//  Created by Valentin Hartig on 21.04.20.
//

import ArgumentParser
import Foundation



// Command to create a new bubo repository
extension Bubo {
    struct New: ParsableCommand {
        static let configuration = CommandConfiguration(
            abstract: "Create a new Bubo project",
            discussion: "Creates a new Bubo project in the current directory. The default project name is the name of the current directory. To speecify a dedicated projeect name use the corresponding option" )
        
        @Argument(help: "Creates the new project in a dedicated directory and gives it a specified project name")
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
            let resourceManager = ResourceManager()
            resourceManager.initProject(name: projectName)
        }
    }
}
