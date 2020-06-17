//
//  Created by Valentin Hartig on 23.04.20.
//

import Foundation


extension ResourceManager {
    
    /// Initialises a new project and registeres it in the root configuration.
    ///
    /// - parameter pName: The name of the project to create. If `pName` is nil, the program creates a new project in the current directory,
    ///                    else it creates a new directory with the name `pName` where the project is initialised in.
    /// - returns: Returns a boolean value that indicates if the project has successfully been created

    func newProject(pName: String?) -> Bool {
        let projectHandle: String
        let projectURL: URL
        var inNewDirectory: Bool
        
        /// Create the current directory path
        guard let currentDirURL = URL(string: fileManager.currentDirectoryPath) else {
            errorMessage(msg: "Can't get current directory path")
            return false
        }
        
        /// Prepare initialisation in new directory or in current directory
        if pName != nil {
            projectHandle = pName!
            inNewDirectory = true
        } else {
            projectHandle = fileManager.displayName(atPath: currentDirURL.path)
            inNewDirectory = false
        }
        
        headerMessage(msg: "Starting initialisation of \(projectHandle)")
        
        /// Check if a project of this name already exists
        if rootConfig.projects?.keys.contains(projectHandle) ?? false { // nil -> project does not exist
            guard let url = rootConfig.projects?[projectHandle] else {
                return false
            }
            
            errorMessage(msg: "Can't create project because a project with the name \(projectHandle) already exist!\nPath: \(url)\nBubo does not support duplicate project names in the current release")
            return false
        }
        
        /// Check if the project needs to be created in a new directory or in the current directory and create the project URL
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
        
        /// Create project configurration data
        let configData: ProjectConfiguration = ProjectConfiguration(
            url: projectURL,
            projectName: projectHandle,
            lastUpdated: Date().description(with: .current)
        )
        
        /// Create the path for the project configuration file and check if the file already exists
        let configURL = projectURL
            .appendingPathComponent("projectConfiguration")
            .appendingPathExtension("json")
        
        guard !self.fileManager.fileExists(atPath: configURL.path) else {
            warningMessage(msg: "A Project has already been intialised in this dirctory! Please delete existing project and try again.")
            return false
        }
        
        /// Try to generate config file
        guard let data = encodeDataToJSON(config: configData) else {
            abortMessage(msg: "Project initialisation")
            return false
        }
        
        /// Create the configuration file at its dedicated URL with the generatedconfiguration data
        let isCreated = self.fileManager
            .createFile(atPath: configURL.path, contents: data, attributes: nil)
        if isCreated {
            outputMessage(msg: "Project config file created at path: \(configURL.path)")
            
            /// Initialise projects if this is the first project
            if rootConfig.projects == nil {
                rootConfig.projects = [:]
            }
            
            /// Add project to the root configuration and reencode the root configuration to persist changes
            rootConfig.projects?[projectHandle] = projectURL
            encodeRootConfig(config: rootConfig)
        } else {
            errorMessage(msg: "Project config file can't be created at path: \(configURL.path)")
            return false
        }
        successMessage(msg: "Project \(projectHandle) has been initialised and is located at \(projectURL.path)")
        return true
    }
}
