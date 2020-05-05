//
//  Created by Valentin Hartig on 27.04.20.
//

import Foundation
import ArgumentParser

extension Bubo {
    struct List: ParsableCommand {
        static let configuration = CommandConfiguration(
            abstract: "List all Bubo projects.")
        
        
        func run() {
            let colorBubo = "Bubo".blue()
            headerMessage(msg: "All \(colorBubo) projects")
            guard let projects = rootConfig.projects else {
                errorMessage(msg: "Can't list projects because Bubo has not been initialised.")
                return
            }
            if projects.isEmpty {
                print("No projects have been created. Use the Bubo new command to create a project.")
            } else {
                for (projectName, projectURL) in projects {
                    let name = projectName.blue().underline()
                    let url = projectURL.path.yellow()
                    print("\(name) -> \(url)")
                }
            }
        }
    }
}
