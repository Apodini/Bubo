//
//  Created by Valentin Hartig on 28.04.20.
//

import Foundation

extension ResourceManager {
    func removeProject(projectName: String?) -> Void {
        
        guard var (projectHandle, projects) = self.fetchProjects(projectName: projectName) else {
                   abortMessage(msg: "Deregistering project")
                   return
        }
        
        headerMessage(msg: "Removing project \(projectHandle)")
        
        guard let url = projects.removeValue(forKey: projectHandle) else {
            errorMessage(msg: "Can't remove \(projectHandle). It does not exists in Bubo runtime configuration")
            return
        }
        
        let fileManager = FileManager.default
        let fileURL = URL(fileURLWithPath: url.path)
        do {
            try fileManager.removeItem(at: fileURL)
            self.setProjects(projects: projects)
            successMessage(msg: "Removed project \(projectHandle)")
            return
        } catch {
            errorMessage(msg: "Failed to remove project \(projectHandle)")
            return
        }
    }
}
