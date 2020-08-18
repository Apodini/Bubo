//
//  DecodeProjectConfig.swift
//  Bubo
//
//  Created by Valentin Hartig on 06/05/20
//  Copyright © 2020 TUM LS1. All rights reserved.
//

import Foundation


// MARK: ResourceManager
extension ResourceManager {
    
    /// Decodes a project configuration based on a project name
    ///
    /// - parameter projectName: The name of the project. If `projectName` is nil, the program checks if the current directory name is a project.
    /// - returns: The validated project handle and the project configuration data
    public func decodeProjectConfig(pName: String?) -> (String, ProjectConfiguration)? {
        
        /// Validates the project name and fetches the `projectHandle` and the `projectURL`
        guard let (projectHandle, projectURL) = self.getProjectURL(projectName: pName) else {
            abortMessage(msg: "Refresh services")
            return nil
        }
        
        /// Checks if a configuration at the project configuration path exists and trys to decode it 
        let configURL = projectURL.appendingPathComponent("projectConfiguration").appendingPathExtension("json")
        let fileURL = URL(fileURLWithPath: configURL.path)
        guard let projectConfig = decodeProjectConfigfromJSON(url: fileURL) else {
            return nil
        }
        return (projectHandle, projectConfig)
    }
}
