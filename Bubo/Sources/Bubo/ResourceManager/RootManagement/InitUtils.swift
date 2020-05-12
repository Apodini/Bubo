//
//  Created by Valentin Hartig on 12.05.20.
//

import Foundation

extension ResourceManager {
    // Fetch root directory for initialisation
    func getRootDir() -> URL? {
        guard let filePath = rootConfig.rootUrl else {
            errorMessage(msg: "Can't get Bubo root repository path")
            return nil
        }
        return filePath
    }
    
    // Fetch root config path for initialisation check and decoding of configurations
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
}
