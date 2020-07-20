//
//  Created by Valentin Hartig on 28.04.20.
//

import Foundation
import ResourceManagerModule


extension OperationsManager {
    
    /// Removes a project and all its subdirectories permanently from disk. Use with special care!
    ///
    /// - parameter pName: The name of the project to remove. If `pName` is nil, the program checks if the current directory name is a project and removes it.
    
    public func removeProject(pName: String?) -> Void {
        
        guard var (projectHandle, projects) = self.resourceManager.fetchHandleAndProjects(pName: pName) else {
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
            self.resourceManager.setProjects(projects: projects)
            successMessage(msg: "Removed project \(projectHandle)")
            return
        } catch {
            errorMessage(msg: "Failed to remove project \(projectHandle)")
            return
        }
    }
}
