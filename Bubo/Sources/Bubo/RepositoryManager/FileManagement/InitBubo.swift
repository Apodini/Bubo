//
//  Created by Valentin Hartig on 23.04.20.
//

import Foundation

extension FileManagment {
    
    // Checks if the root repository of the application has been initialised
    func checkInit() -> Bool {
        guard getBuboConfigPath() != nil else {
            return false
        }
        return true // Initialised if root config file exists
    }
    
    func initBubo(configFile: Buborc) -> Bool {
        headerMessage(msg: "Starting initialisation of Bubo")
        // Create directory path for bubos root directory
        guard let filePath = getBuboRepoDir() else {
            errorMessage(msg: "Can't initialise Bubo in standard repositories. Please initialise Bubo manually.")
            return false
        }
        
        // Create path for root config file
        let configPath = filePath
            .appendingPathComponent("buborc")
            .appendingPathExtension("json")
        
        if !self.fileManager.fileExists(atPath: filePath.path) {
            do {
                // Try to generate the root directory at path
                try self.fileManager.createDirectory(atPath: filePath.path, withIntermediateDirectories: true, attributes: nil)
                // Create config file Data
                if !self.fileManager.fileExists(atPath: configPath.path) {
                    // Encode config file data
                    let data: Data = encodeDataToJSON(config: configFile)
                    successMessage(msg: "Root configuration has been encoded in JSON \(data)")
                    // Try to generate config file at above metioned path
                    let isCreated = fileManager.createFile(atPath: configPath.path, contents: data, attributes: nil)
                    if isCreated {
                        rootConfig = configFile
                        successMessage(msg: "Root configuration file created at path: \(configPath)")
                    } else {
                        errorMessage(msg: "Root configuration file can't be created at path: \(configPath)")
                        return false
                    }
                } else {
                    updateBuborc(config: configFile, path: configPath)
                }
            } catch {
                errorMessage(msg: "Couldn't create Bubo root directory at path \(filePath.path)")
                return false
            }
            successMessage(msg: "Root directory is \(filePath)")
            return true
        }
        return true
    }
}
