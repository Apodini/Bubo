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
            NSLog("ERROR: Can't get root repo url path in getBuboRepoDir()")
            return nil
        }
        return filePath
    }
    
    func getBuboConfigPath() -> URL? {
        // Create directory path for bubos root directory
        guard let filePath = getBuboRepoDir() else {
            NSLog("ERROR: Can't get bubo root path")
            return nil
        }
        if self.fileManager.fileExists(atPath: filePath.path) {
            // Create path for root config file
            let configPath = URL(fileURLWithPath: filePath
                .appendingPathComponent("buborc")
                .appendingPathExtension("json").path)
            
            if self.fileManager.fileExists(atPath: configPath.path) {
                return configPath
            }
        }
        return nil
    }
    
    
    func updateBuborc(config: Buborc, path: URL) {
        // Compare existing config file with new one and update existing
        NSLog("buborc at path \(path) updated")
    }
}
