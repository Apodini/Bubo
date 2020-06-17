//
//  Created by Valentin Hartig on 28.04.20.
//

import Foundation

extension ResourceManager {
    
    /// Prints all services of a project to stdout
    ///
    /// - parameter projectName: The name of the project  for which all services should be printed. If `projectName` is nil, the program checks if the current directory name is a project.
    
    func printServices(projectName: String?) -> Void {
        
        /// Get the `projectHandle` that identifies the project in the roots `projects`
        guard let (projectHandle, projectConfig) = self.decodeProjectConfig(pName: projectName) else {
            abortMessage(msg: "List services")
            return
        }
        
        /// Make it fancy
        let colorProjektName = projectHandle.blue()
        headerMessage(msg: "Services in project \(colorProjektName)")
        
        /// Get the projects services
        let services = projectConfig.repositories
        if services.isEmpty {
            warningMessage(msg: "No services have been added to \(projectHandle). Add new services to the project with the add command.")
            return
        }
        
        /// Sort the services be name and print them to stdout
        let sortedServices = services.keys.sorted()
        for serviceName in sortedServices {
            let name = serviceName.blue().underline()
            let serviceURL = services[serviceName]
            if serviceURL != nil {
                print("\(name) -> \(serviceURL?.absoluteString.yellow())")
            }
        }
    }
}
