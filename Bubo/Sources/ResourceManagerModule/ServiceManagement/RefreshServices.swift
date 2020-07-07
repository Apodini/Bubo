//
//  Created by Valentin Hartig on 12.05.20.
//

import Foundation
import ShellOut
import BuboModelsModule
import OutputStylingModule

extension ResourceManager {
    
    /// Checks a projects service directory for new, deleted or changed services and refreshes the project configuration
    ///
    /// - parameter projectName: The name of the project to refresh. If `projectName` is nil, the program checks if the current directory name is a project.
    /// - returns: A boolean value to indicate if the projectt refresh was successfu
    
    public func refreshServices(projectName: String?) -> Void {
        
        /// Get the `projecHandle` and the project configuration `projectConfig`
        guard var (projectHandle, projectConfig) = self.decodeProjectConfig(pName: projectName) else {
               abortMessage(msg: "Refresh services")
               return
        }
        outputMessage(msg: "Refreshing services for \(projectHandle)")
       
        /// Save currently persisted services
        let prevServicesURLs = projectConfig.repositories
        var prevServices: [String:ServiceConfiguration] = [:]
        
        for (serviceName, _) in prevServicesURLs {
            if let (_, serviceConfig) = self.decodeServiceConfig(pName: projectHandle, serviceName: serviceName) {
                prevServices[serviceName] = serviceConfig
            }
        }
        
        // There should never be other files except the services in the services diectory!
        /// Create the service directory URL and check if a directory exists
        let servicesURL = projectConfig.url.appendingPathComponent("services")
        if fileManager.fileExists(atPath: servicesURL.path) {
            do {
                outputMessage(msg: "Generating services for all items in \(projectHandle)s service directory")
                
                /// Get all service URLs for services in the service directory
                let directoryItems: [URL] = try fileManager.contentsOfDirectory(at: servicesURL, includingPropertiesForKeys: nil)
                var services: [String:ServiceConfiguration] = [:]
                
                /// Generate new service configuration data objects for all service URLs
                for url in directoryItems {
                    guard let service = fetchServiceFromURL(serviceURL: url) else {
                        abortMessage(msg: "Refresh services")
                        return
                    }
                    services[service.name] = service
                }
                outputMessage(msg: "Compare found services with services registered in project configuration")
                var updatedServices: [String:ServiceConfiguration] = [:]
                
                /// Compare currently persisted services with new services if service dosen't exist then add it, else merge the old and the new service
                for (_,newService) in services {
                        if prevServices.values.contains(newService) {
                            for (_, oldService) in prevServices {
                                if oldService == newService {
                                    
                                    /// Merge graphsnapshots
                                    var graphsnapshots: [URL] = newService.graphSnapshots
                                    for url in oldService.graphSnapshots {
                                        if !newService.graphSnapshots.contains(url) {
                                            graphsnapshots.append(url)
                                        }
                                    }
                                    
                                    /// Generate an updated service configuration data object from the new and the old service
                                    let tmpService = ServiceConfiguration(
                                        name: oldService.name,
                                        url: newService.url,
                                        gitURL: newService.gitRemoteURL,
                                        currentGitHash: newService.currentGitHash,
                                        files: newService.files,
                                        dateCloned: oldService.dateCloned,
                                        lastUpdated: newService.lastUpdated,
                                        graphSnapshots: graphsnapshots)
                                    updatedServices[tmpService.name] = tmpService
                                }
                            }
                        } else {
                            updatedServices[newService.name] = newService
                            outputMessage(msg: "Added new service \(newService.name)")
                        }
                    }
                
                /// Update the project configuration and encode it to persist changes
                var updatedServicesURLs: [String: URL] = [:]
                for (name, service) in updatedServices {
                    if let serviceConfigURL = self.encodeServiceConfig(pName: projectHandle, configData: service) {
                        updatedServicesURLs[name] = serviceConfigURL
                    }
                }
                outputMessage(msg: "Update configuration file for \(projectHandle)")
                projectConfig.repositories = updatedServicesURLs
                projectConfig.lastUpdated = Date().description(with: .current)
                self.encodeProjectConfig(pName: projectHandle, configData: projectConfig)
                successMessage(msg: "Refreshed services for \(projectHandle)")
                return
            } catch {
                errorMessage(msg: "Can't fetch contents of the projects services directory at path \(servicesURL.path)")
                return
            }
        } else {
            errorMessage(msg: "Project \(projectHandle) has no services directory. Please check if the driectory exists or clone a new sevice with Bubo add projectName gitURL")
            return 
        }
    }
}
