//
//  Created by Valentin Hartig on 23.04.20.
//

import Foundation


extension FileManagment {
    // ----------------------- New repository initialisation functions
    func initNewRepo(name: String) -> Bool {
        NSLog("Starting initialisation of new repo")
        // Create the directory name
        var dirName = name
        dirName.append("Anchor")
        // Create the directory path
        guard let rootPath = getBuboRepoDir() else {
            NSLog("ERROR: Can't get root path in initNewRepo()")
            return false
        }
        let repoPath = rootPath.appendingPathComponent("\(name)")
        
        guard !self.fileManager.fileExists(atPath: repoPath.path) else {
            NSLog("A Project with this name already exists!")
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
                    repositories: [],
                    lastUpdated: Date().description(with: .current)
                )
                if !self.fileManager.fileExists(atPath: configPath.path) {
                    // Try to generate config file and log progress
                    let data: Data = encodeDataToJSON(config: configFile)
                    let isCreated = self.fileManager
                        .createFile(atPath: configPath.path, contents: data, attributes: nil)
                    if isCreated {
                        NSLog("anchorrc created at path: \(configPath)")
                        if rootConfig.projects == nil {
                            rootConfig.projects = []
                        }
                        rootConfig.projects?.append(repoPath)
                        encodeRootConfig(configFile: rootConfig)
                    } else {
                        NSLog("ERROR: anchorrc can't be created at path: \(configPath)")
                        return false
                    }
                }
            }
        } catch {
            NSLog("Couldn't create \(dirName) directory")
            return false
        }
        NSLog("\(dirName) directory is \(repoPath)")
        return true
    }
}
