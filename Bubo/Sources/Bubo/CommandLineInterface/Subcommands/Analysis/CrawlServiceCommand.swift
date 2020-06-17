//
//  Created by Valentin Hartig on 12.05.20.
//

import Foundation
import ArgumentParser


extension Bubo.Analysis {
    
    /// **Subcommand**: Crawl a specified service and outout all its files to stdout 
    struct Crawl: ParsableCommand {
        static let configuration = CommandConfiguration(
            abstract: "Output all files of a service",
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
            headerMessage(msg: "Found following urls for service \(options.serviceName)")
            for file in resourceManager.fileCrawler(startURL: service.url) {
                print("Name: \(file.fileName)\nPath: \(file.fileURL.path)\n")
            }
        }
    }
}
