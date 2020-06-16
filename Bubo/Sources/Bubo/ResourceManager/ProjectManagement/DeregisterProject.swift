//
//  Created by Valentin Hartig on 06.05.20.
//

import Foundation

extension ResourceManager {
    
    /// Derehisters a project from the root configuration
    ///
    /// - parameter pName: The name of the project to deregister. If `pName` is nil, the program checks if the current directory name is a project
    
    func deregisterProject(pName: String?) -> Void {
        headerMessage(msg: "Deregistering project")

        guard var (projectHandle, projects) = self.fetchHandleAndProjects(pName: pName) else {
            abortMessage(msg: "Deregistering project")
            return
        }
        
        outputMessage(msg: "Removing project \(projectHandle) from registered projects")
        projects.removeValue(forKey: projectHandle)

        self.setProjects(projects: projects)
        successMessage(msg: "Deregistered project \(projectHandle)")
    }
}
