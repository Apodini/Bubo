//
//  Created by Valentin Hartig on 12.05.20.
//

import Foundation
import ArgumentParser

extension Bubo.Analysis {
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
            
            guard let (projectHandle, projektConfig) = resourceManager.decodeProjectConfig(pName: options.projectName) else {
                errorMessage(msg: "Can't crawl, sorry")
                return
            }
            guard let service = projektConfig.repositories[options.serviceName] else {
                errorMessage(msg: "I hate error messages!!!!")
                return
            }
            headerMessage(msg: "Found following urls for service \(options.serviceName)")
            for file in resourceManager.fileCrawler(startURL: service.url) {
                print("Name: \(file.fileName)\nPath: \(file.fileURL.path)\n")
            }
        }
    }
}
