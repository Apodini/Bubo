//
//  Created by Valentin Hartig on 01.05.20.
//

import Foundation
import ShellOut
import BuboModelsModule
import OutputStylingModule

extension ResourceManager {
    
    /// Pull latest changes on a services git repository
    ///
    /// - parameters:
    ///     - projectName: The name of the project where the service is located. If `projectName` is nil, the program checks if the current directory name is a project.
    ///     - serviceName: The name of the service you want to pull.
    
    public func pullService(projectName: String?, serviceName: String) -> Void {
        
        /// Refresh the services of the project to make sure all services (also manually cloned) are registered and up to date
        self.refreshServices(projectName: projectName)

        /// Get the `projecHandle` and the service configuration `service`
        guard let (projectHandle, service) = self.decodeServiceConfig(pName: projectName, serviceName: serviceName) else {
            abortMessage(msg: "Pull service \(serviceName)")
            return
        }
        
        headerMessage(msg: "Pulling service \(service.name) in \(projectHandle)")
        
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
    
    public func pullAllServices(projectName: String?) -> Void {
        
        /// Get the `projecHandle` and the project configuration `projectConfig`
        guard let (projectHandle, projectConfig) = self.decodeProjectConfig(pName: projectName) else {
            abortMessage(msg: "Pull all services")
            return
        }
        
        headerMessage(msg: "Pulling all services in \(projectHandle)")
        
        /// Refresh the services of the project to make sure all services (also manually cloned) are registered and up to date
        self.refreshServices(projectName: projectHandle)
        
        /// Iterate over all projects and try to pull changes
        for (serviceName, _) in projectConfig.repositories {
            
            if let (_,serviceConfig) = decodeServiceConfig(pName: projectHandle, serviceName: serviceName) {
                if fileManager.changeCurrentDirectoryPath(serviceConfig.url.path) {
                    do {
                        let output = try shellOut(to: "git pull")
                        outputMessage(msg: output)
                        outputMessage(msg: "Pulled \(serviceConfig.name) in \(projectHandle) successfully")
                    } catch {
                        let error = error as! ShellOutError
                        print(error.message) // Prints STDERR
                        print(error.output) // Prints STDOUT
                        errorMessage(msg: "Failed to pull project \(projectHandle)")
                        return
                    }
                } else {
                    errorMessage(msg: "Failed to open the direectory of service \(serviceConfig.name)")
                }
            }
        }
        
        /// Refresh services again to bring the current commit hash up to date
        self.refreshServices(projectName: projectHandle)
        successMessage(msg: "Pulled all services in \(projectHandle) successfully")
    }
}
