//
//  Created by Valentin Hartig on 17.05.20.
//


import Foundation
import ArgumentParser


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
            let resourceManager = ResourceManager()
            guard let (projectHandle, service) = resourceManager.decodeServiceConfig(pName: options.projectName, serviceName: options.serviceName) else {
                errorMessage(msg: "Can't crawl, sorry")
                return
            }
            headerMessage(msg: "Parsing \(options.serviceName)")
            let serviceManager = ServiceManager(service: service, pName: options.projectName)
            guard let graph = serviceManager.createDependencyGraph() else {
                return
            }
//            outputMessage(msg: "Writing graph to .dot output file and saving it in current directory")
//            let filemnger = FileManager()
//            let url = URL(fileURLWithPath: filemnger.currentDirectoryPath).appendingPathComponent("\(service.name)").appendingPathExtension("dot")
//            do {
//                try graph.description.write(to: url, atomically: false, encoding: .utf8)
//                successMessage(msg: "Graph output is at \(url.path)")
//            } catch {
//                warningMessage(msg: "Couldn't write graph to dot file")
//            }
            
        }
    }
}
