//
//  Created by Valentin Hartig on 23.04.20.
//

import Foundation
import BuboModelsModule
import OutputStylingModule

extension ResourceManager {
    
    /// Initialieses the application based on passed configuration data
    ///
    /// - parameter configData: An application configuration that provides the environment context for the application.
    ///                         Based on this configuration data the applications root configuration is created.
    
    public func initRoot(configData: ProgramConfiguration) -> Void {
        headerMessage(msg: "Starting initialisation of Bubo")
        
        /// Create directory path for the application configuration directory
        guard let rootDirURL = getRootDir() else {
            errorMessage(msg: "Can't initialise Bubo in standard repositories. Please initialise Bubo manually.")
            abortMessage(msg: "Bubo initialisation")
            return
        }
        
        /// Create path for root configuration file
        let configURL = rootDirURL
            .appendingPathComponent("buborc")
            .appendingPathExtension("json")
        
        /// Check if there is already an existing configuration directory. If so do nothing
        if !self.fileManager.fileExists(atPath: rootDirURL.path) {
            do {
                
                /// Try to generate the root directory where all application configuration files are going to live
                try self.fileManager.createDirectory(atPath: rootDirURL.path, withIntermediateDirectories: true, attributes: nil)
                outputMessage(msg: "Root diectory created at \(rootDirURL.path)")
               
                /// Check if there is already an existing configuration file in the directory (Just to be safe)
                if !self.fileManager.fileExists(atPath: configURL.path) {
                    
                    /// Encode configuration file data in JSON
                    guard let jsonData: Data = encodeDataToJSON(config: configData) else {
                        abortMessage(msg: "Bubo initialisation")
                        return
                    }
                    
                    /// Try to generate configuration file at its dedicated URL
                    let isCreated = fileManager.createFile(atPath: configURL.path, contents: jsonData, attributes: nil)
                    if isCreated {
                        rootConfig = configData
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
