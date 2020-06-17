//
//  Created by Valentin Hartig on 06.05.20.
//

import Foundation

extension ResourceManager {
    
    
    /// Fetches all projects from the root configuration and checks if the provided project name exists.
    ///
    /// - parameter pName: The name of the project to retrieve. If `pName` is nil, the program checks if the current directory name is a project.
    /// - returns: A tuple that consists of the `projectHandle` and the `projects` dictionary. The `projectHandle` is the key that identifies the project
    /// in the dictionary.
    
    public func fetchHandleAndProjects(pName: String?) -> (projectHandle: String, projects: [String:URL])? {
        
        /// Check if project name was passed, if not choose current directory as projectHandle
        let projectHandle: String
        if pName != nil {
            projectHandle = pName!
        } else {
            projectHandle = fileManager.displayName(atPath: fileManager.currentDirectoryPath)
        }
        
        /// Get projects from the root configuration
        guard let projects = rootConfig.projects  else {
            errorMessage(msg: "Can't fetch Bubo projects")
            return nil
        }
        
        /// Check if a project for the projectHandle exists
        if !projects.keys.contains(projectHandle) { // nil -> project does not exist
            errorMessage(msg: "There is no project with the name \(projectHandle) registered in the root configuration. Use bubo new to create a new project")
            return nil
        }
        
        return (projectHandle, projects)
    }
}
