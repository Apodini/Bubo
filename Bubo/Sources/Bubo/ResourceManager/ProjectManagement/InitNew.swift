//
//  Created by Valentin Hartig on 23.04.20.
//

import Foundation


extension ResourceManager {
  // ----------------------- New project initialisation
    func initProject(name: String?) -> Bool {
        let projectHandle: String
        let projectURL: URL
        var inNewDirectory: Bool
        
        // Create the current directory path
        guard let currentDirURL = URL(string: fileManager.currentDirectoryPath) else {
            errorMessage(msg: "Can't get current directory path")
            return false
        }
        
        // Prepare initialisation
        if name != nil { // in new directory
            projectHandle = name!
            inNewDirectory = true
        } else { // in current directroy
            projectHandle = fileManager.displayName(atPath: currentDirURL.path)
            inNewDirectory = false
        }
        
        headerMessage(msg: "Starting initialisation of \(projectHandle)")
        
        // Check if a project of this name already exists
        if rootConfig.projects?.keys.contains(projectHandle) ?? false { // nil -> project does not exist
            guard let url = rootConfig.projects?[projectHandle] else {
                return false
            }
            
            errorMessage(msg: "Can't create project because a project with the name \(projectHandle) already exist!\nPath: \(url)\nBubo does not support duplicate project names in the current release")
            return false
        }
        
        if inNewDirectory {
            projectURL = currentDirURL.appendingPathComponent("\(projectHandle)")
            
            guard !self.fileManager.fileExists(atPath: projectURL.path) else {
                warningMessage(msg: "A directory with this name already exists! Please delete existing directory")
                return false
            }
            
            do {
                // Generate the directory at the directory path
                try self.fileManager.createDirectory(atPath: projectURL.path, withIntermediateDirectories: true, attributes: nil)
                outputMessage(msg: "Created project directory at path \(projectURL.path)")
            } catch {
                errorMessage(msg: "Couldn't create \(projectHandle) project at path \(projectURL.path)")
                return false
            }
        } else {
            projectURL = currentDirURL
        }
        // Create anchor config file
        let configData: Anchorrc = Anchorrc(
            url: projectURL,
            projectName: projectHandle,
            lastUpdated: Date().description(with: .current)
        )
        
        // Create the path for the config file of the new repo
        let configURL = projectURL
            .appendingPathComponent("anchorrc")
            .appendingPathExtension("json")
        
        guard !self.fileManager.fileExists(atPath: configURL.path) else {
            warningMessage(msg: "A Project has already been intialised in this dirctory! Please delete existing project and try again.")
            return false
        }
        
        // Try to generate config file and log progress
        guard let data = encodeDataToJSON(config: configData) else {
            abortMessage(msg: "Project initialisation")
            return false
        }
        
        let isCreated = self.fileManager
            .createFile(atPath: configURL.path, contents: data, attributes: nil)
        if isCreated {
            outputMessage(msg: "Project config file created at path: \(configURL.path)")
            if rootConfig.projects == nil {
                rootConfig.projects = [:]
            }
            rootConfig.projects?[projectHandle] = projectURL
            encodeRootConfig(configFile: rootConfig)
        } else {
            errorMessage(msg: "Project config file can't be created at path: \(configURL.path)")
            return false
        }
        successMessage(msg: "Project \(projectHandle) has been initialised and is located at \(projectURL.path)")
        return true
    }
}
