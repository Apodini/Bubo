//
//  Created by Valentin Hartig on 30.06.20.
//


import Foundation
import ArgumentParser
import BuboModelsModule
import OutputStylingModule
import ServiceManagerModule


extension Bubo.Analysis {
    
    /// **Subcommand**: Subcommand to generate a dependency graph and save it to a .dot file
    struct ClusterGraph: ParsableCommand {
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
            guard let (projectHandle, service) = Main.resourceManager.decodeServiceConfig(pName: options.projectName, serviceName: options.serviceName) else {
                errorMessage(msg: "Can't crawl, sorry")
                return
            }
            headerMessage(msg: "Parsing \(options.serviceName)")
            let serviceManager = ServiceManager(service: service, pName: options.projectName)
            guard let graph = serviceManager.clusterGraphByClasses() else {
                return
            }
            
            print(graph)
        }
    }
}
