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
}
