//
//  Created by Valentin Hartig on 23.04.20.
//

import Foundation


extension FileManagment {
    // ----------------------- New repository initialisation functions
    func initNewRepo(name: String) -> Bool {
        headerMessage(msg: "Starting initialisation of \(name)")
        // Create the directory name
        var dirName = name
        dirName.append("Anchor")
        // Create the directory path
        guard let rootPath = getBuboRepoDir() else {
            errorMessage(msg: "Can't get root path in initNewRepo()")
            return false
        }
        let repoPath = rootPath.appendingPathComponent("\(name)")
        
        guard !self.fileManager.fileExists(atPath: repoPath.path) else {
            warningMessage(msg: "A Project with this name already exists! Please delete existing project.")
            return false
        }
        
        do {
            // Generate the directory at the directory path
            try self.fileManager.createDirectory(atPath: repoPath.path, withIntermediateDirectories: true, attributes: nil)
            if self.fileManager.fileExists(atPath: repoPath.path) {
                // Create the path for the config file of the new repo
                let configPath = repoPath
                    .appendingPathComponent("anchorrc")
                    .appendingPathExtension("json")
                // Create anchor config file
                let configFile: Anchorrc = Anchorrc(
                    url: repoPath,
                    projectName: name,
                    creator: "NSFullUserName()",
                    lastUpdated: Date().description(with: .current)
                )
                if !self.fileManager.fileExists(atPath: configPath.path) {
                    // Try to generate config file and log progress
                    let data: Data = encodeDataToJSON(config: configFile)
                    let isCreated = self.fileManager
                        .createFile(atPath: configPath.path, contents: data, attributes: nil)
                    if isCreated {
                        successMessage(msg: "Project config file created at path: \(configPath)")
                        if rootConfig.projects == nil {
                            rootConfig.projects = [:]
                        }
                        rootConfig.projects?[name] = repoPath
                        encodeRootConfig(configFile: rootConfig)
                    } else {
                        errorMessage(msg: "Project config file can't be created at path: \(configPath)")
                        return false
                    }
                }
            }
        } catch {
            errorMessage(msg: "Couldn't create \(name) project")
            return false
        }
        successMessage(msg: "Project \(name) is located at \(repoPath)")
        return true
    }
}
