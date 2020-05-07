//
//  Created by Valentin Hartig on 28.04.20.
//

import Foundation

extension RepositoryManagement {
    func removeService(projectName: String?, serviceName: String) -> Void {
        guard let (projectHandle,_) = fileManagement.fetchProjects(projectName: projectName) else {
            abortMessage(msg: "Deregistering project")
            return
        }
        
        headerMessage(msg: "Removing service \(serviceName) from \(projectHandle)")
        guard var projectConfig = fileManagement.decodeProjectConfig(projectName: projectName) else {
            abortMessage(msg: "Removing service \(serviceName) in project \(projectHandle)")
            return
        }
        var services = projectConfig.repositories
        
        guard let service = services.removeValue(forKey: serviceName) else {
            errorMessage(msg: "No service named \(serviceName) in project \(projectHandle)")
            return
        }
        
        let fileURL = URL(fileURLWithPath: service.url.path)
        do {
            try fileManager.removeItem(at: fileURL)
            successMessage(msg: "Removed service \(serviceName) from project \(projectHandle)")
            projectConfig.repositories = services
            projectConfig.lastUpdated = Date().description(with: .current)
            fileManagement.encodeProjectConfig(projectName: projectHandle, configData: projectConfig)
            return
        } catch {
            errorMessage(msg: "Failed to remove service \(serviceName) from project \(projectHandle)")
            return
        }
        
    }
}
