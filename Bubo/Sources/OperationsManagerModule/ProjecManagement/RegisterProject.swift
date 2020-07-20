//
//  Created by Valentin Hartig on 20.07.20.
//

import Foundation
import ResourceManagerModule


extension OperationsManager {
    public func registerProject() -> Void {
        
        guard let currentDirURL = URL(string: fileManager.currentDirectoryPath) else {
            errorMessage(msg: "Can't get current directory path")
            return
        }
        
        let projectHandle = fileManager.displayName(atPath: currentDirURL.path)
        
        let configURL = currentDirURL
        .appendingPathComponent("projectConfiguration")
        .appendingPathExtension("json")
        
        guard fileManager.fileExists(atPath: configURL.path) else {
            errorMessage(msg: "No porject has been intitalised in this directory.")
            return
        }
        
        if self.resourceManager.rootConfig.projects == nil {
            self.resourceManager.rootConfig.projects = [:]
        }
        
        /// Add project to the root configuration and reencode the root configuration to persist changes
        self.resourceManager.rootConfig.projects?[projectHandle] = currentDirURL
        self.resourceManager.encodeRootConfig(config: self.resourceManager.rootConfig)
        successMessage(msg: "Project \(projectHandle) has been registered and is located at \(currentDirURL.path)")
    }
}
