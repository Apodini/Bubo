//
//  Created by Valentin Hartig on 23.04.20.
//

import Foundation

extension FileManagment {
    
    // Checks if the root repository of the application has been initialised
    func checkInit() -> Bool {
        guard getRootConfigPath() != nil else {
            return false
        }
        return true // Initialised if root config file exists
    }
    
    func initBubo(configFile: Buborc) -> Void {
        headerMessage(msg: "Starting initialisation of Bubo")
        // Create directory path for bubos root directory
        guard let rootDirURL = getRootDir() else {
            errorMessage(msg: "Can't initialise Bubo in standard repositories. Please initialise Bubo manually.")
            return
        }
        
        // Create path for root config file
        let configURL = rootDirURL
            .appendingPathComponent("buborc")
            .appendingPathExtension("json")
        
        if !self.fileManager.fileExists(atPath: rootDirURL.path) {
            do {
                // Try to generate the root directory at path
                try self.fileManager.createDirectory(atPath: rootDirURL.path, withIntermediateDirectories: true, attributes: nil)
                // Create config file Data
                if !self.fileManager.fileExists(atPath: configURL.path) {
                    // Encode config file data
                    let data: Data = encodeDataToJSON(config: configFile)
                    successMessage(msg: "Root configuration has been encoded in JSON \(data)")
                    // Try to generate config file at above metioned path
                    let isCreated = fileManager.createFile(atPath: configURL.path, contents: data, attributes: nil)
                    if isCreated {
                        rootConfig = configFile
                        successMessage(msg: "Root configuration file created at path: \(configURL)")
                    } else {
                        errorMessage(msg: "Root configuration file can't be created at path: \(configURL)")
                        return
                    }
                } else {
                    updateRootConfig(config: configFile, path: configURL)
                }
            } catch {
                errorMessage(msg: "Couldn't create Bubo root directory at path \(rootDirURL.path)")
                return
            }
            successMessage(msg: "Root directory is \(rootDirURL)")
        }
    }
}
