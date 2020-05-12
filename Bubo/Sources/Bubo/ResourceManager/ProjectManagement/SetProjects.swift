//
//  Created by Valentin Hartig on 06.05.20.
//

import Foundation

extension ResourceManager {
    
    public func setProjects(projects: [String:URL]) -> Void {
        rootConfig.projects = projects
        self.encodeRootConfig(configFile: rootConfig)
    }
}
