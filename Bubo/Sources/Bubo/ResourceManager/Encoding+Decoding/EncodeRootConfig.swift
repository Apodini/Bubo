//
//  File.swift
//  
//
//  Created by Valentin Hartig on 06.05.20.
//

import Foundation

extension ResourceManager {
    
    /// Encode a root configuration to persist it as the working configuration for the application
    ///
    /// - parameter config: The application root configuration that should be encoded
    
    func encodeRootConfig(config: Buborc) -> Void {
        
        /// Fetch the root configuration file UR
        guard let configURL = getRootConfigPath() else {
            abortMessage(msg: "Encoding of root configuration")
            return
        }
        
        /// Encode the `config` data to JSON
        let encode = encodeDataToJSON(config: rootConfig)
        
        /// Remove the current configuration file and create the new one
        do {
            try fileManager.removeItem(at: configURL)
        } catch {
            errorMessage(msg: "Root configuration file can't be overwritten at path: \(configURL.path)")
            return
        }
        let isCreated = fileManager.createFile(atPath: configURL.path, contents: encode, attributes: nil)
        if isCreated {
            rootConfig = config
            return
        } else {
            errorMessage(msg: "Root configuration file can't be overwritten at path: \(configURL.path)")
            return
        }
    }
}
