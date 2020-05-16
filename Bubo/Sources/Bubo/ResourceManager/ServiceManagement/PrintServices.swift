//
//  Created by Valentin Hartig on 28.04.20.
//

import Foundation

extension ResourceManager {
    func printServices(projectName: String?) -> Void {
        guard let (projectHandle, projectConfig) = self.decodeProjectConfig(pName: projectName) else {
            abortMessage(msg: "List services")
            return
        }
        let colorProjektName = projectHandle.blue()
        headerMessage(msg: "Services in project \(colorProjektName)")
        
        let services = projectConfig.repositories
        if services.isEmpty {
            warningMessage(msg: "No services have been added to \(projectHandle). Add new services to the project with the add command.")
            return
        }
        let sortedServices = services.keys.sorted()
        for serviceName in sortedServices {
            let name = serviceName.blue().underline()
            let service = services[serviceName]
            if service != nil {
                print("\(name) -> \(service!.gitURL.absoluteString.yellow())")
            }
        }
    }
}
