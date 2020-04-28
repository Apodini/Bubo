//
//  Created by Valentin Hartig on 20.04.20.
//

import Foundation
import ShellOut


class RepositoryManagement {
    
    // Checks the projects service directory for new services or deleted services
    func updateServices(projectName: String) -> Bool {
        headerMessage(msg: "Updating services for \(projectName)")
        let fileManagement = FileManagment()
        let fileManager = FileManager.default
        guard var projectConfig = fileManagement.decodeProjectConfig(projectName: projectName) else {
            errorMessage(msg: "Can't update services of \(projectName) because it's not possible to decode the projects runtime configuration")
            return false
        }
        
        let prevServices = projectConfig.repositories
        
        guard let projectURL = fileManagement.getProjectURL(projectName: projectName) else {
            errorMessage(msg: "Can't get project URL for project \(projectName). Please check if the project is initalised.")
            return false
        }
        
        // There should never be other files except the services in the services diectory!
        let servicesURL = projectURL.appendingPathComponent("services")
        
        if fileManager.fileExists(atPath: servicesURL.path) {
            do {
                let directoryItems: [URL] = try fileManager.contentsOfDirectory(at: servicesURL, includingPropertiesForKeys: nil)
                var services: [Service] = []
                for url in directoryItems {
                    guard let service = createService(serviceURL: url) else {
                        errorMessage(msg: "Can't update services because generating a serrvice for \(url.path) is not possible")
                        return false
                    }
                    services.append(service)
                }
                successMessage(msg: "Observe services in services directory of \(projectName)")
                var updatedServices: [Service] = []
                // Compare old services with new services
                    for newService in services {
                        if prevServices.contains(newService) {
                            for oldService in prevServices {
                                if oldService == newService {
                                    updatedServices.append(oldService)
                                }
                            }
                        } else {
                            updatedServices.append(newService)
                        }
                    }
                successMessage(msg: "Compare state of services")
                projectConfig.repositories = updatedServices
                projectConfig.lastUpdated = Date().description(with: .current)
                fileManagement.encodeProjectConfig(projectName: projectName, configData: projectConfig)
                successMessage(msg: "Update configuration file for \(projectName)")
                return true
            } catch {
                errorMessage(msg: "Can't fetch contents of the projects services directory at path \(servicesURL.path)")
                return false
            }
        } else {
            errorMessage(msg: "Project \(projectName) has no services directory. Please check if the driectory exists or clone a new sevice with Bubo add projectName gitURL")
            return false
        }
    }
    
    func createService(serviceURL: URL) -> Service? {
        let fileManager = FileManager.default
        let name = fileManager.displayName(atPath: serviceURL.path)
        
        do {
            let gitURLstring = try shellOut(to: "git -C \(serviceURL.path) config --get remote.origin.url")
            guard let gitURL = URL(string: gitURLstring) else {
                errorMessage(msg: "Can't parse the git remote URL \(gitURLstring) for service \(serviceURL.path) into the URL format. Aborting service creation")
                return nil
            }
            return Service(name: name, url: serviceURL, gitURL: gitURL)
        } catch {
            errorMessage(msg: "Can't read the git remote URL for \(serviceURL.path) Aborting service creation")
            return nil
        }
    }
}
