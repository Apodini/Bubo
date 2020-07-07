//
//  Created by Valentin Hartig on 20.04.20.
//

import Foundation
import BuboModelsModule

public class ResourceManager {
    
    /// A public filemanager object that unifies the use of the same filemanager in all extensions
    public var fileManager: FileManager
    public var rootConfig: ProgramConfiguration = ProgramConfiguration(
        version: "0.0.1",
        projects: [:]
    )
    public var initStatus: Bool = false
    
    public init() {
        self.fileManager = FileManager.default
        /// Check if the program has been initalised
        initStatus = self.checkInit()
        if !initStatus {
            /// if not present: initialise Bubo
            self.initRoot(configData: rootConfig)
            initStatus = self.checkInit()
        } else {
            /// else decode the root configuration
            self.decodeRootConfig()
        }
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
