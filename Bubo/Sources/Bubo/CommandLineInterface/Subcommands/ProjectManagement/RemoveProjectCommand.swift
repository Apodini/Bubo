//
//  Created by Valentin Hartig on 28.04.20.
//

import ArgumentParser
import Foundation
import ResourceManagerModule


extension Bubo {
    
    /// **Subcommand**:  Remove a project from the registerd projects
    struct Remove: ParsableCommand {
        static let configuration = CommandConfiguration(
            abstract: "Remove a Bubo project",
            discussion: "Removes a Bubo project and ALL its contents permanently if the flag is set. Please be careful with this command"
        )
        
        @OptionGroup()
        var options: Bubo.OptionsPNonly
        
        @Flag(help: "Remove the procject permanently from disk (not recommended)")
        var permanently: Bool
        
        func validate() throws {
            if options.projectName != nil {
                let name = options.projectName!
                guard name.count <= 255 else {
                    throw ValidationError("Project name is too long!")
                }
            }
        }
        
        func run() {
            if permanently {
                Main.operationsManager.removeProject(pName: options.projectName)
            } else {
                Main.operationsManager.deregisterProject(pName: options.projectName)
            }
        }
    }
}
