//
//  Created by Valentin Hartig on 06.05.20.
//

import Foundation

extension FileManagment {
    func deregisterProject(projectName: String) -> Void {
        headerMessage(msg: "Deregistering project \(projectName)")
        outputMessage(msg: "Fetching projects from root configuration")
        guard var projects = rootConfig.projects  else {
            errorMessage(msg: "Can't fetch Bubo projects.")
            return
        }
        outputMessage(msg: "Removing project \(projectName) from registered projects")
        guard let url = projects.removeValue(forKey: projectName) else {
            errorMessage(msg: "Can't remove \(projectName). It does not exists in Bubo runtime configuration")
            return
        }
        successMessage(msg: "Deregistered project \(projectName)")
    }
}
