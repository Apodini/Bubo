//
//  Created by Valentin Hartig on 23.04.20.
//

import Foundation

extension ResourceManager {
    func initRoot(configFile: Buborc) -> Void {
        headerMessage(msg: "Starting initialisation of Bubo")
        // Create directory path for bubos root directory
        guard let rootDirURL = getRootDir() else {
            // errorMessage(msg: "Can't initialise Bubo in standard repositories. Please initialise Bubo manually.")
            abortMessage(msg: "Bubo initialisation")
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
                outputMessage(msg: "Root diectory created at \(rootDirURL.path)")
                // Create config file Data
                if !self.fileManager.fileExists(atPath: configURL.path) {
                    // Encode config file data
                    guard let data: Data = encodeDataToJSON(config: configFile) else {
                        abortMessage(msg: "Bubo initialisation")
                        return
                    }
                    // Try to generate config file at above metioned path
                    let isCreated = fileManager.createFile(atPath: configURL.path, contents: data, attributes: nil)
                    if isCreated {
                        rootConfig = configFile
                        outputMessage(msg: "Root configuration file created at path: \(configURL.path)")
                    } else {
                        errorMessage(msg: "Root configuration file can't be created at path: \(configURL.path)")
                        return
                    }
                }
            } catch {
                errorMessage(msg: "Couldn't create Bubo root directory at path \(rootDirURL.path)")
                return
            }
            successMessage(msg: "Bubo has been successfully initialisd")
        }
    }
}
