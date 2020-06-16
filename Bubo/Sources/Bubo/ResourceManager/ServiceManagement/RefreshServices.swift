//
//  Created by Valentin Hartig on 12.05.20.
//

import Foundation
import ShellOut

extension ResourceManager {
    
    /// Checks a projects service directory for new, deleted or changed services and refreshes the project configuration
    ///
    /// - parameter projectName: The name of the project to refresh. If `projectName` is nil, the program checks if the current directory name is a project.
    /// - returns: A boolean value to indicate if the projectt refresh was successfu
    
    func refreshServices(projectName: String?) -> Bool {
        
        /// Get the `projecHandle` and the project configuration `projectConfig`
        guard var (projectHandle, projectConfig) = self.decodeProjectConfig(pName: projectName) else {
               abortMessage(msg: "Refresh services")
               return false
        }
        outputMessage(msg: "Refreshing services for \(projectHandle)")
       
        /// Save currently persisted services
        let prevServices = projectConfig.repositories
        
        // There should never be other files except the services in the services diectory!
        /// Create the service directory URL and check if a directory exists
        let servicesURL = projectConfig.url.appendingPathComponent("services")
        if fileManager.fileExists(atPath: servicesURL.path) {
            do {
                outputMessage(msg: "Generating services for all items in \(projectHandle)s service directory")
                
                /// Get all service URLs for services in the service directory
                let directoryItems: [URL] = try fileManager.contentsOfDirectory(at: servicesURL, includingPropertiesForKeys: nil)
                var services: [String:Service] = [:]
                
                /// Generate new service configuration data objects for all service URLs
                for url in directoryItems {
                    guard let service = fetchServiceFromURL(serviceURL: url) else {
                        abortMessage(msg: "Refresh services")
                        return false
                    }
                    services[service.name] = service
                }
                outputMessage(msg: "Compare found services with services registered in project configuration")
                var updatedServices: [String:Service] = [:]
                
                /// Compare currently persisted services with new services if service dosen't exist then add it, else merge the old and the new service
                for (_,newService) in services {
                        if prevServices.values.contains(newService) {
                            for (_, oldService) in prevServices {
                                if oldService == newService {
                                    
                                    /// Generate an updated service configuration data object from the new and the old service
                                    let tmpService = Service(
                                        name: oldService.name,
                                        url: newService.url,
                                        gitURL: newService.gitRemoteURL,
                                        currentGitHash: newService.currentGitHash, // If newService gitHash is the same as old service build hash, the don't rebuild
                                        currentBuildGitHash: oldService.currentBuildGitHash, // Expected that the new service was not build
                                        files: newService.files,
                                        dateCloned: oldService.dateCloned,
                                        lastUpdated: newService.lastUpdated)
                                    updatedServices[tmpService.name] = tmpService
                                }
                            }
                        } else {
                            updatedServices[newService.name] = newService
                            outputMessage(msg: "Added new service \(newService.name)")
                        }
                    }
                
                /// Update the project configuration and encode it to persist changes
                outputMessage(msg: "Update configuration file for \(projectHandle)")
                projectConfig.repositories = updatedServices
                projectConfig.lastUpdated = Date().description(with: .current)
                self.encodeProjectConfig(pName: projectHandle, configData: projectConfig)
                successMessage(msg: "Refreshed services for \(projectHandle)")
                return true
            } catch {
                errorMessage(msg: "Can't fetch contents of the projects services directory at path \(servicesURL.path)")
                return false
            }
        } else {
            errorMessage(msg: "Project \(projectHandle) has no services directory. Please check if the driectory exists or clone a new sevice with Bubo add projectName gitURL")
            return false
        }
    }
}
