//
//  Created by Valentin Hartig on 01.05.20.
//

import Foundation
import ShellOut

extension RepositoryManagement {
    
    func pullService(projectName: String, serviceName: String) -> Void {
        headerMessage(msg: "Pulling service \(serviceName) in \(projectName)")
        let fileManagement = FileManagment()
        let fileManager = FileManager.default
        guard let projectConfig = fileManagement.decodeProjectConfig(projectName: projectName) else {
            errorMessage(msg: "Can't pull service \(serviceName) in \(projectName) because it's not possible to decode the projects runtime configuration")
            return
        }
        let services = projectConfig.repositories
        
        guard let service = services[serviceName] else {
            errorMessage(msg: "No service named \(serviceName) in project \(projectName)")
            return
        }
        
        if fileManager.changeCurrentDirectoryPath(service.url.path) {
            do {
                let output = try shellOut(to: "git pull")
                print(output)
                successMessage(msg: "Pulled \(serviceName) in \(projectName) successful.")
                return
            } catch {
                let error = error as! ShellOutError
                print(error.message) // Prints STDERR
                print(error.output) // Prints STDOUT
                errorMessage(msg: "Failed to pull project \(projectName).")
                return
            }
        } else {
            errorMessage(msg: "Failed to open the direectory of service \(service.name)")
        }
    }
    
    func pullAllServices(projectName: String) -> Void {
        headerMessage(msg: "Pulling all services in \(projectName)")
        let fileManagement = FileManagment()
        let fileManager = FileManager.default
        guard let projectConfig = fileManagement.decodeProjectConfig(projectName: projectName) else {
            errorMessage(msg: "Can't pull services in \(projectName) because it's not possible to decode the projects runtime configuration")
            return
        }
        let services = projectConfig.repositories
        
        for (serviceName,service) in services {
            if fileManager.changeCurrentDirectoryPath(service.url.path) {
                do {
                    let output = try shellOut(to: "git pull")
                    print(output)
                    successMessage(msg: "Pulled \(serviceName) in \(projectName) successful.")
                } catch {
                    let error = error as! ShellOutError
                    print(error.message) // Prints STDERR
                    print(error.output) // Prints STDOUT
                    errorMessage(msg: "Failed to pull project \(projectName).")
                    return
                }
            } else {
                errorMessage(msg: "Failed to open the direectory of service \(service.name)")
            }
        }
    }
}
