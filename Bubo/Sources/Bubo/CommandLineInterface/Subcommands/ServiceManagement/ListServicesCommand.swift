//
//  Created by Valentin Hartig on 27.04.20.
//

import Foundation
import ArgumentParser

extension Bubo.Service {
    struct List: ParsableCommand {
        static let configuration = CommandConfiguration(
            abstract: "List all services of a specific project")
        
        @OptionGroup()
        var options: Bubo.OptionsPNonly
        
        // Validate Input
        func validate() throws {
            if options.projectName != nil {
                let tmp = name!
                guard tmp.count <= 255 else {
                    throw ValidationError("Project name is too long!")
                }
            }
        }
        
        func run() {
            let repositoryManagement = ResourceManager()
            repositoryManagement.printServices(projectName: options.projectName)
        }
    }
}
