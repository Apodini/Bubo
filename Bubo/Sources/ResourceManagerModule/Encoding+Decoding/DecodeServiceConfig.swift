//
//  Created by Valentin Hartig on 17.06.20.
//

import Foundation


extension ResourceManager {
    
    /// Decodes a service configuration based on a project name
    ///
    /// - parameters:
    ///     - projectName: The name of the project. If `projectName` is nil, the program checks if the current directory name is a project.
    ///     - serviceName: The name of the service that should be decoded
    /// - returns: The validated project handle and the service configuration data
    
    public func decodeServiceConfig(pName: String?, serviceName: String) -> (projectHandle: String, serviceConfig: ServiceConfiguration)? {
        
        /// Validates the project name and fetches the `projectHandle` and the `projectURL`
        guard let (projectHandle, projectURL) = self.getProjectURL(projectName: pName) else {
            abortMessage(msg: "Refresh services")
            return nil
        }
        
        /// Checks if a configuration at the project configuration path exists and trys to decode it
        let configURL = projectURL.appendingPathComponent("projectConfiguration").appendingPathExtension("json")
        let fileURL = URL(fileURLWithPath: configURL.path)
        guard let projectConfig: ProjectConfiguration = decodeProjectConfigfromJSON(url: fileURL) else {
            return nil
        }
        
        if projectConfig.repositories.keys.contains(serviceName) {
           
            let serviceConfigURL: URL = URL(fileURLWithPath:projectConfig.url.appendingPathComponent("\(serviceName)_Configuration").appendingPathComponent("configuration").appendingPathExtension("json").path)
            
            guard let serviceConfig: ServiceConfiguration = decodeServiceConfigfromJSON(url: serviceConfigURL) else {
                errorMessage(msg: "Can't decode service \(serviceName) at url \(serviceConfigURL.path)")
                abortMessage(msg: "Decoding service configuration")
                return nil
            }
            return (projectHandle, serviceConfig)
        } else {
            errorMessage(msg: "No service with name \(serviceName)")
            return nil
        }
    }
}
