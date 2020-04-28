//
//  Created by Valentin Hartig on 20.04.20.
//

import Foundation

class FileManagment {
    // ----------------------- Declarations
    public var fileManager: FileManager
    
    // ----------------------- Initialisation
    
    init() {
        self.fileManager = FileManager.default
    }
    
    
    // ----------------------- Root repository initialisation functions
    func getBuboRepoDir() -> URL? {
        guard let filePath = rootConfig.rootRepoUrl else {
            errorMessage(msg: "Can't get Bubo root path")
            return nil
        }
        return filePath
    }
    
    func getBuboConfigPath() -> URL? {
        // Create directory path for bubos root directory
        guard let filePath = getBuboRepoDir() else {
            return nil
        }
        if self.fileManager.fileExists(atPath: filePath.path) {
            // Create path for root config file
            let configPath = URL(fileURLWithPath: filePath
                .appendingPathComponent("buborc")
                .appendingPathExtension("json").path)
            
            if self.fileManager.fileExists(atPath: configPath.path) {
                return configPath
            } else {
                errorMessage(msg: "Root configuration does not exist at path \(configPath)")
            }
        }
        return nil
    }
    
    func updateBuborc(config: Buborc, path: URL) {
        // Compare existing config file with new one and update existing
        successMessage(msg: "buborc at path \(path) updated")
    }
    
    func getProjectURL(projectName: String) -> Optional<URL> {
        guard let projects = rootConfig.projects else {
            errorMessage(msg: "Can't get projects from runtime configuration.")
            return nil
        }
        
        let projectNames = rootConfig.projects?.keys
        
        // Check if the project with projectName exists and created if the --new flag is set and it dosen't exist
        if !(projectNames?.contains(projectName) ?? false) {
            errorMessage(msg: "Can't add service because \(projectName) is not existing. Use Bubo new \(projectName) to initialise the new project or use the --new option on th add command")
            return nil
        }
        return projects[projectName]
    }
}
