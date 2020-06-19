//
//  Created by Valentin Hartig on 28.04.20.
//

import Foundation

extension ResourceManager {
    
    /// Removes service from project configuration and deletes it permanently from disk. Use with caution!
    ///
    /// - parameters:
    ///     - projectName: The name of the project from which the service is removed. If `projectName` is nil, the program checks if the current directory name is a project.
    ///     - serviceName: The name of the service you want to remove.
    
    func removeService(projectName: String?, serviceName: String) -> Void {
        
        /// Get the `projecHandle` and the project configuration `projectConfig`
        guard var (projectHandle, projectConfig) = self.decodeProjectConfig(pName: projectName) else {
            abortMessage(msg: "Removing service \(serviceName)")
            return
        }
        
        headerMessage(msg: "Removing service \(serviceName) from \(projectHandle)")
        
        /// Fetch services from project configuration and try to remove service with `serviceName`
        var services = projectConfig.repositories
        guard let serviceURL = services.removeValue(forKey: serviceName) else {
            errorMessage(msg: "No service named \(serviceName) in project \(projectHandle)")
            return
        }
        
        /// Fetch service configuration
        guard let (_,serviceConfig) = decodeServiceConfig(pName: projectName, serviceName: serviceName) else {
            abortMessage(msg: "Removing service \(serviceName)")
            return
        }
        
        /// Remove service directory from disk
        let fileURL = URL(fileURLWithPath: serviceConfig.url.path)
        do {
            
            /// Try to remove the service from disk
            try fileManager.removeItem(at: fileURL)
            successMessage(msg: "Removed service directory \(serviceName) from project \(projectHandle)")
        } catch {
            errorMessage(msg: "Failed to remove service directory \(serviceName) from project \(projectHandle)")
            return
        }
        
        /// Remove service configuration file from disk
        let configFileURL = URL(fileURLWithPath: serviceURL.path)
        do {
            
            /// Try to remove the service configuration from disk
            try fileManager.removeItem(at: configFileURL)
            successMessage(msg: "Removed service configuration for \(serviceName) from project \(projectHandle)")
        } catch {
            errorMessage(msg: "Failed to remove service configuration \(serviceName) from project \(projectHandle)")
            errorMessage(msg: "\(configFileURL.path)")
        }
        
        /// Update the project configuration and reencode it to persist changes
        projectConfig.repositories = services
        projectConfig.lastUpdated = Date().description(with: .current)
        self.encodeProjectConfig(pName: projectHandle, configData: projectConfig)
    }
}
