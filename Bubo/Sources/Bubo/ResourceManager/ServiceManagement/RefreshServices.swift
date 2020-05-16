//
//  Created by Valentin Hartig on 12.05.20.
//

import Foundation

extension ResourceManager {
    // Checks the projects service directory for new services or deleted services
    func refreshServices(projectName: String?) -> Bool {
        guard var (projectHandle, projectConfig) = self.decodeProjectConfig(pName: projectName) else {
               abortMessage(msg: "Refresh services")
               return false
           }
        
        outputMessage(msg: "Refreshing services for \(projectHandle)")
       
        let prevServices = projectConfig.repositories
        
        // There should never be other files except the services in the services diectory!
        let servicesURL = projectConfig.url.appendingPathComponent("services")
        
        if fileManager.fileExists(atPath: servicesURL.path) {
            do {
                outputMessage(msg: "Generating services for all items in \(projectHandle)s service directory")
                let directoryItems: [URL] = try fileManager.contentsOfDirectory(at: servicesURL, includingPropertiesForKeys: nil)
                var services: [String:Service] = [:]
                for url in directoryItems {
                    guard let service = fetchServiceFromURL(serviceURL: url) else {
                        abortMessage(msg: "Refresh services")
                        return false
                    }
                    services[service.name] = service
                }
                outputMessage(msg: "Compare found services with services registered in project configuration")
                var updatedServices: [String:Service] = [:]
                // Compare old services with new services and keep old service objects if they already exist
                for (_,newService) in services {
                        if prevServices.values.contains(newService) {
                            for (_, oldService) in prevServices {
                                if oldService == newService {
                                    let tmpService = Service(name: oldService.name, url: newService.url, gitURL: newService.gitURL, files: newService.files, dateCloned: oldService.dateCloned, lastUpdated: newService.lastUpdated)
                                    updatedServices[tmpService.name] = tmpService
                                }
                            }
                        } else {
                            updatedServices[newService.name] = newService
                            outputMessage(msg: "Added new service \(newService.name)")
                        }
                    }
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
