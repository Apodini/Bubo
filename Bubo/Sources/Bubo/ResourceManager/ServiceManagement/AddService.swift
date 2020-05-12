//
//  Created by Valentin Hartig on 28.04.20.
//

import Foundation
import ShellOut
import ColorizeSwift

extension ResourceManager {
    func addGitRepo(projectName: String?, serviceName: String, gitRepoURL: String) -> Bool {

        guard let (projectHandle, projectURL) = self.getProjectURL(projectName: projectName) else {
            abortMessage(msg: "Refresh services")
            return false
        }
        headerMessage(msg: "Adding new service to \(projectHandle)")
        
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
