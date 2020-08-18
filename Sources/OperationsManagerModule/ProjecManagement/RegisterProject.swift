//
//  RegisterProject.swift
//  Bubo
//
//  Created by Valentin Hartig on 20/07/20
//  Copyright © 2020 TUM LS1. All rights reserved.
//


import Foundation
import ResourceManagerModule


// MARK: OperationsManager
extension OperationsManager {
    
    // Checks if the current directory of the user is a project and if yes registers it in the root config
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
