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
    
    public func encodeServiceConfig(pName: String?, configData: ServiceConfiguration) -> URL? {
        
        /// Fetch projects and validate project name
        guard let (_, projectConfig) = self.decodeProjectConfig(pName: pName) else {
            abortMessage(msg: "Encoding of service configuration")
            return nil
        }
        
        let dirURL: URL = projectConfig.url.appendingPathComponent("\(configData.name)_Configuration")
        
        if !self.fileManager.fileExists(atPath: dirURL.path)  {
            do {
                // Generate the directory at the directory path
                try self.fileManager.createDirectory(atPath: dirURL.path, withIntermediateDirectories: true, attributes: nil)
            } catch {
                errorMessage(msg: "Couldn't create directory for service configuration at path \(dirURL.path)")
                return nil
            }
        }
        
        /// Fetch the projects configuration file URL
        let configURL: URL = dirURL.appendingPathComponent("configuration").appendingPathExtension("json")
        
        /// Encode the configuration data to JSON
        guard let encode = encodeDataToJSON(config: configData) else {
            abortMessage(msg: "Encoding of service configuration")
            return nil
        }
        
        /// Remove the current configuration file and create the nwe configuration file
        let configFileURL = URL(fileURLWithPath: configURL.path)
        if fileManager.fileExists(atPath: configURL.path) {
            do {
                try fileManager.removeItem(at: configFileURL)
            } catch {
                errorMessage(msg: "Can't remove service configuration file for \(configData.name) at path \(configURL)")
            }
        }
        let isCreated = fileManager.createFile(atPath: configURL.path, contents: encode, attributes: nil)
        if !isCreated {
            errorMessage(msg: "Service configuration file for \(configData.name) can't be overwritten at path: \(configURL)")
            return nil
        } else {
            return configURL
        }
    }
}
