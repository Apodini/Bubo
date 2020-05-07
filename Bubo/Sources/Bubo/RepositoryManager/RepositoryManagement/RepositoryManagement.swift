//
//  Created by Valentin Hartig on 20.04.20.
//

import Foundation
import ShellOut


class RepositoryManagement {
    public var fileManager: FileManager
    public var fileManagement: FileManagement


    init() {
        fileManagement = FileManagement()
        fileManager = FileManager.default
    }
    
    // Checks the projects service directory for new services or deleted services
    func refreshServices(projectName: String?) -> Bool {
        guard let (projectHandle,_) = fileManagement.fetchProjects(projectName: projectName) else {
            abortMessage(msg: "Deregistering project")
            return false
        }
        outputMessage(msg: "Refreshing services for \(projectHandle)")
        guard var projectConfig = fileManagement.decodeProjectConfig(projectName: projectHandle) else {
            abortMessage(msg: "Refresh services")
            return false
        }
        
        let prevServices = projectConfig.repositories
        
        guard let projectURL = fileManagement.getProjectURL(projectName: projectHandle) else {
            abortMessage(msg: "Refresh services")
            return false
        }
        
        // There should never be other files except the services in the services diectory!
        let servicesURL = projectURL.appendingPathComponent("services")
        
        if fileManager.fileExists(atPath: servicesURL.path) {
            do {
                outputMessage(msg: "Generating services for all items in \(projectHandle)s service directory")
                let directoryItems: [URL] = try fileManager.contentsOfDirectory(at: servicesURL, includingPropertiesForKeys: nil)
                var services: [String:Service] = [:]
                for url in directoryItems {
                    guard let service = createService(serviceURL: url) else {
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
                                    updatedServices[oldService.name] = oldService
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
                fileManagement.encodeProjectConfig(projectName: projectHandle, configData: projectConfig)
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
    
    func createService(serviceURL: URL) -> Service? {
        let fileManager = FileManager.default
        let name = fileManager.displayName(atPath: serviceURL.path)
    
        do {
            let gitURLstring = try shellOut(to: "git -C \(serviceURL.path) config --get remote.origin.url")
            guard let gitURL = URL(string: gitURLstring) else {
                errorMessage(msg: "Can't parse the git remote URL \(gitURLstring) for service \(serviceURL.path) into the URL format")
                abortMessage(msg: "Service creation")
                return nil
            }
            return Service(name: name, url: serviceURL, gitURL: gitURL)
        } catch {
            errorMessage(msg: "Can't read the git remote URL for \(serviceURL.path)")
            abortMessage(msg: "Service creation")
            return nil
        }
    }
}
