//
//  Created by Valentin Hartig on 20.04.20.
//

import Foundation

class FileManagement {
    
    public var fileManager: FileManager
    
    init() {
        self.fileManager = FileManager.default
    }
    
    func getRootDir() -> URL? {
        guard let filePath = rootConfig.rootUrl else {
            errorMessage(msg: "Can't get Bubo root repository path")
            return nil
        }
        return filePath
    }
    
    func getRootConfigPath() -> URL? {
        // Create directory path for bubos root directory
        guard let filePath = getRootDir() else {
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
                errorMessage(msg: "Can't get URL for root configuration file: Configuration does not exist at path \(configPath)")
            }
        }
        return nil
    }
    
    
    func getProjectURL(projectName: String) -> Optional<URL> {
        guard let projects = rootConfig.projects else {
            errorMessage(msg: "Can't get project URL for \(projectName) because no projects exists in root configuration")
            return nil
        }
        
        let projectNames = rootConfig.projects?.keys
        
        if !(projectNames?.contains(projectName) ?? false) {
            errorMessage(msg: "Can't get URL for \(projectName) because it is not registered in root configuration. Use Bubo new \(projectName) to initialise the new project")
            return nil
        }
        return projects[projectName]
    }
}
