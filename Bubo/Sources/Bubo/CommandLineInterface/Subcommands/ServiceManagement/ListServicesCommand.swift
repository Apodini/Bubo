//
//  Created by Valentin Hartig on 27.04.20.
//

import Foundation
import ArgumentParser
import OutputStylingModule
import BuboModelsModule


extension Bubo.Service {
    
    /// **Subcommand**:  List all services of a project
    struct List: ParsableCommand {
        static let configuration = CommandConfiguration(
            abstract: "List all services of a specific project")
        
        @OptionGroup()
        var options: Bubo.OptionsPNonly
        
        // Validate Input
        func validate() throws {
                guard options.projectName?.count ?? 0 <= 255 else {
                    throw ValidationError("Project name is too long!")
                }
        }
        
        func run() {
            Main.resourceManager.printServices(projectName: options.projectName)
        }
    }
}
