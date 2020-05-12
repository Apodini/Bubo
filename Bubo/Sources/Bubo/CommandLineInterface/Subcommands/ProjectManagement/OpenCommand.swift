//
//  Created by Valentin Hartig on 01.04.20.
//

import Foundation
import ArgumentParser

extension Bubo {
    struct Open: ParsableCommand {
        static let configuration = CommandConfiguration(
            abstract: "Opens a specific project in the finder")
        
        @Argument(help: "The name of the Bubo project that should be opened")
        var projectName: String?
        
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
            resourceManager.openProject(projectName: projectName)
        }
    }
}

