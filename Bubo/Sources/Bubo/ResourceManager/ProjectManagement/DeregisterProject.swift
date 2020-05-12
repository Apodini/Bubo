//
//  Created by Valentin Hartig on 06.05.20.
//

import Foundation

extension ResourceManager {
    func deregisterProject(pName: String?) -> Void {
        headerMessage(msg: "Deregistering project")

        guard var (projectHandle, projects) = self.fetchProjects(pName: pName) else {
            abortMessage(msg: "Deregistering project")
            return
        }
        
        outputMessage(msg: "Removing project \(projectHandle) from registered projects")
        projects.removeValue(forKey: projectHandle)

        self.setProjects(projects: projects)
        successMessage(msg: "Deregistered project \(projectHandle)")
    }
}
