//
//  Created by Valentin Hartig on 17.05.20.
//


import Foundation
import ArgumentParser

extension Bubo.Analysis {
    struct Parse: ParsableCommand {
        static let configuration = CommandConfiguration(
            abstract: "Parses all files of a service and outputs the graph",
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
            let serviceManager = ServiceManager()
            guard let (projectHandle, projektConfig) = resourceManager.decodeProjectConfig(pName: options.projectName) else {
                errorMessage(msg: "Can't crawl, sorry")
                return
            }
            guard let service = projektConfig.repositories[options.serviceName] else {
                errorMessage(msg: "I hate error messages!!!!")
                return
            }
            headerMessage(msg: "Parsing graph for \(options.serviceName)")
            print(serviceManager.parser.parse(service: service).graph)
        }
    }
}