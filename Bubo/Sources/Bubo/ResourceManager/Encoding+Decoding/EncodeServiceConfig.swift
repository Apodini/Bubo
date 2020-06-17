//
//  Created by Valentin Hartig on 17.06.20.
//

import Foundation


extension ResourceManager {
    
    /// Encodes passed service configuration data for a project
    ///
    /// - parameters:
    ///     - pName: The project name
    ///     - configData: The configuration data that should be encoded for the project
    
    func encodeServiceConfig(pName: String?, configData: ServiceConfiguration) -> Void {
        
        /// Fetch projects and validate project name
        guard let (projectHandle, projectConfig) = self.decodeProjectConfig(pName: pName) else {
            abortMessage(msg: "Encoding of service configuration")
            return
        }
        
        /// Fetch the projects configuration file URL
        guard let configURL = projectConfig.repositories[configData.name]?.appendingPathComponent("\(configData.name)_Configuration").appendingPathExtension("json") else {
            errorMessage(msg: "Can't get service configuration file path for \(configData.name). Does the service exist?")
            return
        }
        
        /// Encode the configuration data to JSON
        guard let encode = encodeDataToJSON(config: configData) else {
            abortMessage(msg: "Encoding of service configuration")
            return
        }
        
        /// Remove the current configuration file and create the nwe configuration file
        let configFileURL = URL(fileURLWithPath: configURL.path)
        do {
            try fileManager.removeItem(at: configFileURL)
        } catch {
            errorMessage(msg: "Can't remove service configuration file for \(configData.name) at path \(configURL)")
        }
        let isCreated = fileManager.createFile(atPath: configURL.path, contents: encode, attributes: nil)
        if !isCreated {
            errorMessage(msg: "Service configuration file for \(configData.name) can't be overwritten at path: \(configURL)")
            return
        }
    }
}
