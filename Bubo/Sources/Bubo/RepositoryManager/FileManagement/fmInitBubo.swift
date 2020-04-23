//
//  Created by Valentin Hartig on 23.04.20.
//

import Foundation

extension FileManagment {
    
    // Checks if the root repository of the application has been initialised
    func checkInit() -> Bool {
        guard let filePath = self.getBuboRepoDir() else {
            return false
        }
        let configPath = filePath
            .appendingPathComponent("buborc")
            .appendingPathExtension("json")
        if self.fileManager.fileExists(atPath: configPath.path) {
            return true // Initialised if root config file exists
        } else {
            return false // Not initialised if root config file is not existent
        }
    }
    
    func initBubo(configFile: Buborc) -> Bool {
        NSLog("Starting initialisation of root repo")
        // Create directory path for bubos root directory
        guard let filePath = getBuboRepoDir() else {
            NSLog("ERROR: Can't initialise Bubo in standard repositories. Please initialise Bubo manually.")
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
                    NSLog("Data has been encoded in JSON \(data)")
                    // Try to generate config file at above metioned path
                    let isCreated = fileManager.createFile(atPath: configPath.path, contents: data, attributes: nil)
                    if isCreated {
                        rootConfig = configFile
                        NSLog("buborc created at path: \(configPath)")
                    } else {
                        NSLog("ERROR: buborc can't be created at path: \(configPath)")
                        return false
                    }
                } else {
                    updateBuborc(config: configFile, path: configPath)
                }
            } catch {
                NSLog("Couldn't create bubo roor directory at path \(filePath.path)")
                return false
            }
            NSLog("Root directory is \(filePath)")
            return true
        }
        return true
    }
}
