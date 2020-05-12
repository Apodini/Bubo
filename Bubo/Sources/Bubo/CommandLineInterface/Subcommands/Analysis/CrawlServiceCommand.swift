//
//  Created by Valentin Hartig on 12.05.20.
//

import Foundation
import ArgumentParser

extension Bubo.Analysis {
    struct Crawl: ParsableCommand {
        static let configuration = CommandConfiguration(
            abstract: "Crawl a service of a specific project")
        
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
            let serviceManager = ServiceManager()
            let resourceManager = ResourceManager()
            
            guard let (projectHandle, projektConfig) = resourceManager.decodeProjectConfig(pName: options.projectName) else {
                errorMessage(msg: "Can't crawl, sorry")
                return
            }
            guard let service = projektConfig.repositories[options.serviceName] else {
                errorMessage(msg: "I hate error messages!!!!")
                return
            }
            headerMessage(msg: "Found following urls for service \(options.projectName)")
            for file in serviceManager.fileCrawler(startURL: service.url) {
                print(file.fileURL.path)
            }
        }
    }
}
