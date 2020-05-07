//
//  Created by Valentin Hartig on 01.05.20.
//

import Foundation
import ShellOut

extension RepositoryManagement {
    
    func pullService(projectName: String?, serviceName: String) -> Void {
        
        guard let (projectHandle,_) = fileManagement.fetchProjects(projectName: projectName) else {
            abortMessage(msg: "Deregistering project")
            return
        }
        
        headerMessage(msg: "Pulling service \(serviceName) in \(projectHandle)")
        self.refreshServices(projectName: projectHandle)
        guard let projectConfig = fileManagement.decodeProjectConfig(projectName: projectHandle) else {
            abortMessage(msg: "Pull service \(serviceName) in \(projectHandle)")
            return
        }

        let services = projectConfig.repositories
        
        guard let service = services[serviceName] else {
            errorMessage(msg: "No service named \(serviceName) exists in project \(projectHandle)")
            return
        }
        
        if fileManager.changeCurrentDirectoryPath(service.url.path) {
            do {
                let output = try shellOut(to: "git pull")
                outputMessage(msg: output)
                successMessage(msg: "Pulled \(serviceName) in \(projectHandle) successfully")
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
    
    func pullAllServices(projectName: String?) -> Void {
        guard var (projectHandle, projects) = fileManagement.fetchProjects(projectName: projectName) else {
            abortMessage(msg: "Deregistering project")
            return
        }
        
        headerMessage(msg: "Pulling all services in \(projectHandle)")
        self.refreshServices(projectName: projectHandle)
        guard let projectConfig = fileManagement.decodeProjectConfig(projectName: projectName) else {
            abortMessage(msg: "Pull all services in \(projectHandle)")
            return
        }
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
        successMessage(msg: "Pulled all services in \(projectHandle) successfully")
    }
}
