//
//  Created by Valentin Hartig on 17.06.20.
//

import Foundation


extension ResourceManager {
    
    /// Decodes a project configuration based on a project name
    ///
    /// - parameter projectName: The name of the project. If `projectName` is nil, the program checks if the current directory name is a project.
    /// - returns: The validated project handle and the project configuration data
    
    func decodeServiceConfig(pName: String?, serviceName: String) -> (projectHandle: String, serviceConfig: ServiceConfiguration)? {
        
        /// Validates the project name and fetches the `projectHandle` and the `projectURL`
        guard let (projectHandle, projectURL) = self.getProjectURL(projectName: pName) else {
            abortMessage(msg: "Refresh services")
            return nil
        }
        
        /// Checks if a configuration at the project configuration path exists and trys to decode it
        let configURL = projectURL.appendingPathComponent("anchorrc").appendingPathExtension("json")
        let fileURL = URL(fileURLWithPath: configURL.path)
        guard let projectConfig: ProjectConfiguration = decodeProjectConfigfromJSON(url: fileURL) else {
            return nil
        }
        
        guard let serviceConfigURL: URL = projectConfig.repositories[serviceName] else {
            errorMessage(msg: "Can't decode service with name \(serviceName). Not such a service.")
            abortMessage(msg: "Decoding service configuration")
            return nil
        }
        
        guard let serviceConfig: ServiceConfiguration = decodeServiceConfigfromJSON(url: serviceConfigURL) else {
            errorMessage(msg: "Can't decode service \(serviceName) at url \(serviceConfigURL.path)")
            abortMessage(msg: "Decoding service configuration")
            return nil
        }
        return (projectHandle, serviceConfig)
    }
}
