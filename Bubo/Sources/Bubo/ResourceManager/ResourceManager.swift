//
//  Created by Valentin Hartig on 20.04.20.
//

import Foundation

class ResourceManager {
    
    /// A public filemanager object that unifies the use of the same filemanager in all extensions
    public var fileManager: FileManager
    
    init() {
        self.fileManager = FileManager.default
    }
    
    /// Fetches the projectHandle and the project URL for a given project
    ///
    /// - parameter projectName: The name of the project. If `projectName` is nil, the program checks if the current directory name is a project.
    
    func getProjectURL(projectName: String?) -> (projectHandle: String, projectURL: URL)? {
        guard let (projectHandle, projects) = fetchHandleAndProjects(pName: projectName) else {
            return nil
        }
        guard let projectURL = projects[projectHandle] else {
            return nil
        }
        return (projectHandle, projectURL)
    }
}
