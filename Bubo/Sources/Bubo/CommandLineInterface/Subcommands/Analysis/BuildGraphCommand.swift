//
//  Created by Valentin Hartig on 17.05.20.
//


import Foundation
import ArgumentParser
import OutputStylingModule
import BuboModelsModule
import ServiceManagerModule


extension Bubo.Analysis {
    
    /// **Subcommand**: Subcommand to generate a dependency graph and save it to a .dot file
    struct Graph: ParsableCommand {
        static let configuration = CommandConfiguration(
            abstract: "Parses all files of a service and outputs the graph as a .dot file",
            discussion: "This command is only for testing the new features")
        
        @OptionGroup()
        var options: Bubo.Options
        
        // Validate Input
        func validate() throws {
            if options.projectName != nil {
                let name = options.projectName!
                guard name.count <= 255 else {
                    throw ValidationError("Project name is too long!")
                }
            }
            
            guard options.serviceName.count <= 255 else {
                    throw ValidationError("Service name is too long!")
                }
        }
        
        func run() {
            guard let (_, service) = Main.resourceManager.decodeServiceConfig(pName: options.projectName, serviceName: options.serviceName) else {
                errorMessage(msg: "Can't crawl, sorry")
                return
            }
            let serviceManager = ServiceManager(service: service, pName: options.projectName)
            guard serviceManager.createDependencyGraph() != nil else {
                return
            }
            serviceManager.writeToDot()
        }
    }
}
