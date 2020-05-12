//
//  Created by Valentin Hartig on 20.04.20.
//

import Foundation

class ResourceManager {
    
    public var fileManager: FileManager
    
    init() {
        self.fileManager = FileManager.default
    }
    
    
    func getProjectURL(projectName: String?) -> (String, URL)? {
        guard let (projectHandle, projects) = fetchProjects(pName: projectName) else {
            return nil
        }
        guard let projectURL = projects[projectHandle] else {
            return nil
        }
        return (projectHandle, projectURL)
    }
    
    // Not sure if I need this function at all
    func resolveProjectURL(url: URL) -> Optional<String> {
        guard let projects = rootConfig.projects else {
            errorMessage(msg: "No projects exists in root configuration")
            return nil
        }
        if projects.keys.contains(url.lastPathComponent) {
            return url.lastPathComponent
        } else {
            return nil
        }
    }
    
    // Not sure if I need this function at all
    func resolveServiceURL(url: URL) -> Service? {
        if url.pathComponents.contains("services") {
            var before: String = "" // Search variable for project name
            var indicator: String = "" // Indicator if services Folder is found
            var after: String = "" // Search variable for service name
            
            for current in url.pathComponents {
                if current == "services" {
                    indicator = current
                } else if indicator == "services" {
                    after = current
                    break
                } else {
                    before = current
                }
            }
            if indicator != "services" {
                warningMessage(msg: "Can't get services directory from resolved path")
                abortMessage(msg: "Service URL Resolving")
                return nil
            }
            
            if after.isEmpty {
                warningMessage(msg: "Resolved URL leads to the services directory instead of a specific service")
                abortMessage(msg: "Service URL Resolving")
                return nil
            }
            
            guard let (_, projectConfig) = self.decodeProjectConfig(pName: before) else {
                abortMessage(msg: "Service URL Resolving")
                return nil
            }
            
            guard let service = projectConfig.repositories[after] else {
                errorMessage(msg: "Can't resolve service URL: No service with the name \(after)")
                abortMessage(msg: "Service URL Resolving")
                return nil
            }
            return service
        }
        return nil
    }
}
