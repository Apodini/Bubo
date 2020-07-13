//
//  Created by Valentin Hartig on 01.04.20.
//

import Foundation
import ArgumentParser
import ResourceManagerModule


extension Bubo {
    
    /// **Subcommand**:  Open a project in the finder
    struct Open: ParsableCommand {
        static let configuration = CommandConfiguration(
            abstract: "Opens a specific project in the finder")
        
        @OptionGroup()
        var options: Bubo.OptionsPNonly
        
        func validate() throws {
            if options.projectName != nil {
                let name = options.projectName!
                guard name.count <= 255 else {
                    throw ValidationError("Project name is too long!")
                }
            }
        }
        
        func run() {
            Main.resourceManager.openProject(pName: options.projectName)
        }
    }
}

