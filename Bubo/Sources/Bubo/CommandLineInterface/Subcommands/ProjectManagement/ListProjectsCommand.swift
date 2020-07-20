//
//  Created by Valentin Hartig on 27.04.20.
//

import Foundation
import ArgumentParser
import ResourceManagerModule


extension Bubo {
    
    /// **Subcommand**:  List all registered projects
    /// - note: Registered projects are persisted in the application root configuration.
    struct List: ParsableCommand {
        static let configuration = CommandConfiguration(
            abstract: "List all Bubo projects")
        
        func run() {
            let colorBubo = "Bubo".blue()
            headerMessage(msg: "All \(colorBubo) projects")
            guard let projects = Main.operationsManager.resourceManager.rootConfig.projects else {
                errorMessage(msg: "Can't list projects because Bubo has not been initialised.")
                return
            }
            if projects.isEmpty {
                print("No projects have been created. Use the Bubo new command to create a project.")
            } else {
                let sortedProjects = projects.keys.sorted()
                for projectName in sortedProjects {
                    let name = projectName.blue().underline()
                    let url = projects[projectName]
                    if url != nil {
                        print("\(name) -> \(url!.path.yellow())")
                    }
                }
            }
        }
    }
}
