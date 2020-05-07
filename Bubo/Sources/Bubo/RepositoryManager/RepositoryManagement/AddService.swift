//
//  Created by Valentin Hartig on 28.04.20.
//

import Foundation
import ShellOut
import ColorizeSwift

extension RepositoryManagement {
    func addGitRepo(projectName: String?, serviceName: String, gitRepoURL: String) -> Bool {
        
        guard var (projectHandle, projects) = fileManagement.fetchProjects(projectName: projectName) else {
            abortMessage(msg: "Deregistering project")
            return false
        }
        headerMessage(msg: "Adding new service to \(projectHandle)")

        
        guard let projectURL = projects[projectHandle] else {
            errorMessage(msg: "Can't add service to \(projectHandle) because no with this name exists in root configuration")
            return false
        }
        
        if let url = URL(string: gitRepoURL) {
            do {
                let gitMessage = try shellOut(to:
                    .gitClone(
                        url: url,
                        to: projectURL
                            .appendingPathComponent("services")
                            .appendingPathComponent(serviceName)
                            .path
                    )
                )
                // outputMessage(msg: gitMessage)
                outputMessage(msg: "Repository has been cloned")
                self.refreshServices(projectName: projectHandle)
            } catch {
                errorMessage(msg: "Can't clone repository from \(url.path)")
                let error = error as! ShellOutError
                print(error.message) // Prints STDERR
                print(error.output) // Prints STDOUT
                return false
            }
        } else {
            errorMessage(msg: "Can't clone repositoy from \(gitRepoURL). The provided URL is not parsable")
            return false
        }
        successMessage(msg: "Added service \(serviceName) to project \(projectHandle)")
        return true
    }
}
