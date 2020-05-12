//
//  Created by Valentin Hartig on 06.05.20.
//

import Foundation

extension ResourceManager {
    // Fetches the projects and checks if the project exists
    public func fetchProjects(projectName: String?) -> (projectHandle: String, projects: [String:URL])? {
        
        let projectHandle: String
        if projectName != nil {
            projectHandle = projectName!
        } else {
            projectHandle = fileManager.displayName(atPath: fileManager.currentDirectoryPath)
        }
        
        outputMessage(msg: "Fetching projects from root configuration")
        guard let projects = rootConfig.projects  else {
            errorMessage(msg: "Can't fetch Bubo projects")
            return nil
        }
        
        if !projects.keys.contains(projectHandle) { // nil -> project does not exist
            errorMessage(msg: "There is no project with the name \(projectHandle) registered in the root configuration. Use bubo new to create a new project")
            return nil
        }
        
        return (projectHandle, projects)
    }
}
