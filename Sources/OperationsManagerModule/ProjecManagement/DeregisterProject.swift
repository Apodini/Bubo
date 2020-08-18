//
//  DeregisterProject.swift
//  Bubo
//
//  Created by Valentin Hartig on 06/05/20
//  Copyright © 2020 TUM LS1. All rights reserved.
//


import Foundation
import ResourceManagerModule


// MARK: OperationsManager
extension OperationsManager {
    
    /// Derehisters a project from the root configuration
    ///
    /// - parameter pName: The name of the project to deregister. If `pName` is nil, the program checks if the current directory name is a project
    public func deregisterProject(pName: String?) -> Void {
        headerMessage(msg: "Deregistering project")

        guard var (projectHandle, projects) = self.resourceManager.fetchHandleAndProjects(pName: pName) else {
            abortMessage(msg: "Deregistering project")
            return
        }
        
        outputMessage(msg: "Removing project \(projectHandle) from registered projects")
        projects.removeValue(forKey: projectHandle)

        self.resourceManager.setProjects(projects: projects)
        successMessage(msg: "Deregistered project \(projectHandle)")
    }
}
