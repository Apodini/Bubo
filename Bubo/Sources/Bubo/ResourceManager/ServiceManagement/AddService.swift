//
//  Created by Valentin Hartig on 28.04.20.
//

import Foundation
import ShellOut
import ColorizeSwift

extension ResourceManager {
    
    /// Adds a new service to a project. The service is cloned from a valid git URL.
    ///
    /// - parameters:
    ///     - projectName: The name of the project to add the service to. If `projectName` is nil, the program checks if the current directory name is a project.
    ///     - serviceName: The name of the service you want to add. It's recommended to choose the same name as the git repository.
    ///     - gitRepoURL: The URL string to the git repository the service is based on.
    /// - returns: A boolean value that indicates if adding the service was successful or not.

    func addService(projectName: String?, serviceName: String, gitRepoURL: String) -> Bool {

        /// Fetch the `projectHandle` and all `projects` registered in the root configuration
        guard let (projectHandle, projectURL) = self.getProjectURL(projectName: projectName) else {
            abortMessage(msg: "Add service")
            return false
        }
        headerMessage(msg: "Adding new service to \(projectHandle)")
        
        /// Try to parse the passed git URL string into the URL foramt
        if let url = URL(string: gitRepoURL) {
            do {
                
                /// Try to clone the repository into the projects services directroy
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
                
                /// Refresh the project configuration with the most recent data about the services in the projects service directory
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
