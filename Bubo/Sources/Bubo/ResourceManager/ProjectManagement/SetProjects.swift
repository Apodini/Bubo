//
//  Created by Valentin Hartig on 06.05.20.
//

import Foundation

extension ResourceManager {
    
    /// Overwrites the root configurations projects dictionary with the passed dictionary.
    ///
    /// - parameter projects: The new projects directory that should be persisted in the root configuration.
    public func setProjects(projects: [String:URL]) -> Void {
        rootConfig.projects = projects
        self.encodeRootConfig(config: rootConfig)
    }
}
