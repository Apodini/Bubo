//
//  Created by Valentin Hartig on 06.05.20.
//

import Foundation

extension ResourceManager {
    
    /// Encodes passed project configuration data for a  project
    ///
    /// - parameters:
    ///     - pName: The project name
    ///     - configData: The configuration data that should be encoded for the project
    
    func encodeProjectConfig(pName: String?, configData: ProjectConfiguration) -> Void {
        
        /// Fetch projects and validate project name
        guard let (projectHandle, projects) = self.fetchHandleAndProjects(pName: pName) else {
            abortMessage(msg: "Encoding of project configuration")
            return
        }
        
        /// Fetch the projects configuration file URL
        guard let configURL = projects[projectHandle]?.appendingPathComponent("projectConfiguration").appendingPathExtension("json") else {
            errorMessage(msg: "Can't get projects configuration file path for \(pName). Does the project exist?")
            return
        }
        
        ///Encode the configuration data to JSON
        guard let encode = encodeDataToJSON(config: configData) else {
            abortMessage(msg: "Encoding of project configuration")
            return
        }
        
        /// Remove the current configuration file and create the nwe configuration file
        let configFileURL = URL(fileURLWithPath: configURL.path)
        do {
            try fileManager.removeItem(at: configFileURL)
        } catch {
            errorMessage(msg: "Can't remove project configuration file for \(pName) at path \(configURL)")
        }
        let isCreated = fileManager.createFile(atPath: configURL.path, contents: encode, attributes: nil)
        if isCreated {
            // successMessage(msg: "Project configuration file for \(projectName) overwritten at path: \(configURL)")
        } else {
            errorMessage(msg: "Project configuration file for \(pName) can't be overwritten at path: \(configURL)")
            return
        }
    }
}
