//
//  Created by Valentin Hartig on 28.04.20.
//

import Foundation
import ShellOut
import ColorizeSwift

extension RepositoryManagement {
    func addGitRepo(projectName: String, serviceName: String, gitRepoURL: String, createNewProject: Bool) -> Bool {
        headerMessage(msg: "Adding new service to \(projectName)")
        let fileManagement = FileManagment()
        let projectNames = rootConfig.projects?.keys
        
        // Check if the project with projectName exists and created if the --new flag is set and it dosen't exist
        if !(projectNames?.contains(projectName) ?? false) {
            if createNewProject {
                fileManagement.initProjectWithName(name: projectName)
                successMessage(msg: "Creating new project \(projectName)")
            } else {
                warningMessage(msg: "Can't add service because \(projectName) is not existing. Use Bubo new \(projectName) to initialise the new project or use the --new option on th add command")
                return false
            }
        }
        guard let projects = rootConfig.projects else {
            errorMessage(msg: "Can't get projects from runtime configuration.")
            return false
        }
        
        guard let projectURL = projects[projectName] else {
            errorMessage(msg: "Can't get project URL from bubo runtime configuration")
            return false
        }
        
        if let url = URL(string: gitRepoURL) {
            do {
                try shellOut(to:
                    .gitClone(
                        url: url,
                        to: projectURL
                            .appendingPathComponent("services")
                            .appendingPathComponent(serviceName)
                            .path
                    )
                )
                successMessage(msg: "Repository has been cloned")
                self.updateServices(projectName: projectName)
            } catch {
                errorMessage(msg: "Can't clone repositoy from \(url.path)")
                let error = error as! ShellOutError
                print(error.message) // Prints STDERR
                print(error.output) // Prints STDOUT
                return false
            }
        } else {
            errorMessage(msg: "Can't clone repositoy from \(gitRepoURL). The provided URL is not parsable")
            return false
        }
        return true
    }
}
