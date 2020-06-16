//
//  Created by Valentin Hartig on 01.05.20.
//

import Foundation
import ShellOut

extension ResourceManager {
    
    /// Pull latest changes on a services git repository
    ///
    /// - parameters:
    ///     - projectName: The name of the project where the service is located. If `projectName` is nil, the program checks if the current directory name is a project.
    ///     - serviceName: The name of the service you want to pull.
    
    func pullService(projectName: String?, serviceName: String) -> Void {
        
        /// Get the `projecHandle` and the project configuration `projectConfig`
        guard let (projectHandle, projectConfig) = self.decodeProjectConfig(pName: projectName) else {
            abortMessage(msg: "Pull service \(serviceName)")
            return
        }
        
        headerMessage(msg: "Pulling service \(serviceName) in \(projectHandle)")
        
        /// Refresh the services of the project to make sure all services (also manually cloned) are registered and up to date
        self.refreshServices(projectName: projectHandle)
        
        /// Try to get the service from the projects services
        let services = projectConfig.repositories
        guard let service = services[serviceName] else {
            errorMessage(msg: "No service named \(serviceName) exists in project \(projectHandle)")
            return
        }
        
        /// Change to service directory and try to pull changes
        if fileManager.changeCurrentDirectoryPath(service.url.path) {
            do {
                let output = try shellOut(to: "git pull")
                outputMessage(msg: output)
                successMessage(msg: "Pulled \(serviceName) in \(projectHandle) successfully")
                
                /// Refresh services again to bring the current commit hash up to date
                self.refreshServices(projectName: projectHandle)
                return
            } catch {
                let error = error as! ShellOutError
                print(error.message) // Prints STDERR
                print(error.output) // Prints STDOUT
                errorMessage(msg: "Failed to pull project \(projectHandle)")
                return
            }
        } else {
            errorMessage(msg: "Failed to open the direectory of service \(service.name)")
        }
    }
    
    
    /// Pull latest changes for all services of a specifc project
    ///
    /// - parameter projectName: The name of the project where the services are located. If `projectName` is nil, the program checks if the current directory name is a project.
    
    func pullAllServices(projectName: String?) -> Void {
        
        /// Get the `projecHandle` and the project configuration `projectConfig`
        guard let (projectHandle, projectConfig) = self.decodeProjectConfig(pName: projectName) else {
            abortMessage(msg: "Pull all services")
            return
        }
        
        headerMessage(msg: "Pulling all services in \(projectHandle)")
        
        /// Refresh the services of the project to make sure all services (also manually cloned) are registered and up to date
        self.refreshServices(projectName: projectHandle)
        
        /// Iterate over all projects and try to pull changes
        let services = projectConfig.repositories
        for (serviceName,service) in services {
            if fileManager.changeCurrentDirectoryPath(service.url.path) {
                do {
                    let output = try shellOut(to: "git pull")
                    outputMessage(msg: output)
                    outputMessage(msg: "Pulled \(serviceName) in \(projectHandle) successfully")
                } catch {
                    let error = error as! ShellOutError
                    print(error.message) // Prints STDERR
                    print(error.output) // Prints STDOUT
                    errorMessage(msg: "Failed to pull project \(projectHandle)")
                    return
                }
            } else {
                errorMessage(msg: "Failed to open the direectory of service \(service.name)")
            }
        }
        
        /// Refresh services again to bring the current commit hash up to date
        self.refreshServices(projectName: projectHandle)
        successMessage(msg: "Pulled all services in \(projectHandle) successfully")
    }
}
