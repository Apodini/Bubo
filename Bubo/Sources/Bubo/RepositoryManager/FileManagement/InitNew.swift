//
//  Created by Valentin Hartig on 23.04.20.
//

import Foundation


extension FileManagment {
    // ----------------------- New project initialisation in current directory
    func initProject() -> Bool {
        headerMessage(msg: "Starting initialisation of new project in current directory")
        // Create the directory path
        guard let projectURL = URL(string: fileManager.currentDirectoryPath) else {
            errorMessage(msg: "Can't get root path in initNewRepo()")
            return false
        }
        let name = self.fileManager.displayName(atPath: projectURL.path)
        
        if rootConfig.projects?.keys.contains(name) ?? false { // nil -> project does not exist
            guard let url = rootConfig.projects?[name] else {
                return false
            }
            errorMessage(msg: "Can't create project because a project with the name \(name) already exists at path \(url). Bubo does not support duplicate project names in the current release. Please consideer a different name.")
            return false
        }

        if self.fileManager.fileExists(atPath: projectURL.path) {
            // Create anchor config file
            let configData: Anchorrc = Anchorrc(
                url: projectURL,
                projectName: name,
                lastUpdated: Date().description(with: .current)
            )
            
            // Create the path for the config file of the new repo
            let configURL = projectURL
                .appendingPathComponent("anchorrc")
                .appendingPathExtension("json")
            
            guard !self.fileManager.fileExists(atPath: configURL.path) else {
                warningMessage(msg: "A Project has already been intialised in this dirctorry! Please delete existing project and try again.")
                return false
            }
            
            // Try to generate config file and log progress
            let data: Data = encodeDataToJSON(config: configData)
            let isCreated = self.fileManager
                .createFile(atPath: configURL.path, contents: data, attributes: nil)
            if isCreated {
                successMessage(msg: "Project config file created at path: \(configURL.path)")
                if rootConfig.projects == nil {
                    rootConfig.projects = [:]
                }
                rootConfig.projects?[name] = projectURL
                encodeRootConfig(configFile: rootConfig)
            } else {
                errorMessage(msg: "Project config file can't be created at path: \(configURL.path)")
                return false
            }
            
        }
        successMessage(msg: "Project \(name) is located at \(projectURL.path)")
        return true
    }
    
    // ----------------------- New project initialisation in dedicated directory
    func initProjectWithName(name: String) -> Bool {
        headerMessage(msg: "Starting initialisation of \(name)")
        // Create the directory path
        guard let currentDirURL = URL(string: fileManager.currentDirectoryPath) else {
            errorMessage(msg: "Can't get root path in initNewRepo()")
            return false
        }
        
        if rootConfig.projects?.keys.contains(name) ?? false { // nil -> project does not exist
            guard let url = rootConfig.projects?[name] else {
                return false
            }
            
            errorMessage(msg: "Can't create project because a project with the name \(name) already exists at path \(url). Bubo does not support duplicate project names in the current release. Please consideer a different name.")
            return false
        }
        
        let projectURL = currentDirURL.appendingPathComponent("\(name)")
        
        guard !self.fileManager.fileExists(atPath: projectURL.path) else {
            warningMessage(msg: "A Project with this name already exists! Please delete existing project.")
            return false
        }
        
        do {
            // Generate the directory at the directory path
            try self.fileManager.createDirectory(atPath: projectURL.path, withIntermediateDirectories: true, attributes: nil)
                // Create the path for the config file of the new repo
                let configURL = projectURL
                    .appendingPathComponent("anchorrc")
                    .appendingPathExtension("json")
                // Create anchor config file
                let configData: Anchorrc = Anchorrc(
                    url: projectURL,
                    projectName: name,
                    lastUpdated: Date().description(with: .current)
                )
                if !self.fileManager.fileExists(atPath: configURL.path) {
                    // Try to generate config file and log progress
                    let data: Data = encodeDataToJSON(config: configData)
                    let isCreated = self.fileManager
                        .createFile(atPath: configURL.path, contents: data, attributes: nil)
                    if isCreated {
                        successMessage(msg: "Project config file created at path: \(configURL)")
                        if rootConfig.projects == nil {
                            rootConfig.projects = [:]
                        }
                        rootConfig.projects?[name] = projectURL
                        encodeRootConfig(configFile: rootConfig)
                    } else {
                        errorMessage(msg: "Project config file can't be created at path: \(configURL)")
                        return false
                    }
                }
        } catch {
            errorMessage(msg: "Couldn't create \(name) project at path \(projectURL.path)")
            return false
        }
        successMessage(msg: "Project \(name) is located at \(projectURL)")
        return true
    }
}
