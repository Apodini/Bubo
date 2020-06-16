//
//  Created by Valentin Hartig on 12.05.20.
//

import Foundation

extension ResourceManager {
    
    /// Fetch application configuration root directory for initialisation.
    ///
    /// - returns: Returns the URL of the root configuration directory if existent. Else it returns nil.
    
    func getRootDir() -> URL? {
        guard let filePath = rootConfig.rootUrl else {
            errorMessage(msg: "Can't get Bubo root repository path")
            return nil
        }
        return filePath
    }
    
    /// Fetch root config path for initialisation check and decoding of configurations.
    ///
    /// - returns: Returns the URL of the root configuration  file  if existent. Else it returns nil.

    func getRootConfigPath() -> URL? {
        
        /// Fetch directory path for bubos root directory
        guard let rootDirectoryURL = getRootDir() else {
            return nil
        }
        
        /// Check if the configuration directory exists
        if self.fileManager.fileExists(atPath: rootDirectoryURL.path) {
            
            /// Create URL for the root configuration file
            let configurationURL = URL(fileURLWithPath: rootDirectoryURL
                .appendingPathComponent("buborc")
                .appendingPathExtension("json").path)
            
            /// Check if the configuration file exists
            if self.fileManager.fileExists(atPath: configurationURL.path) {
                return configurationURL
            } else {
                errorMessage(msg: "Can't get URL for root configuration file: Configuration does not exist at path \(configurationURL)")
            }
        }
        return nil
    }
}
