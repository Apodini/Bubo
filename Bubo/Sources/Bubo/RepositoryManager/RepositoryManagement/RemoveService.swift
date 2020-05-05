//
//  Created by Valentin Hartig on 28.04.20.
//

import Foundation

extension RepositoryManagement {
    func removeService(projectName: String, serviceName: String) -> Void {
        headerMessage(msg: "Removing service \(serviceName) from \(projectName)")
        let fileManagement = FileManagment()
        let fileManager = FileManager.default
        guard var projectConfig = fileManagement.decodeProjectConfig(projectName: projectName) else {
            abortMessage(msg: "Removing service \(serviceName) in project \(projectName)")
            return
        }
        var services = projectConfig.repositories
        
        guard let service = services.removeValue(forKey: serviceName) else {
            errorMessage(msg: "No service named \(serviceName) in project \(projectName)")
            return
        }
        
        let fileURL = URL(fileURLWithPath: service.url.path)
        do {
            try fileManager.removeItem(at: fileURL)
            successMessage(msg: "Removed service \(serviceName) from project \(projectName)")
            projectConfig.repositories = services
            projectConfig.lastUpdated = Date().description(with: .current)
            fileManagement.encodeProjectConfig(projectName: projectName, configData: projectConfig)
            return
        } catch {
            errorMessage(msg: "Failed to remove service \(serviceName) from project \(projectName)")
            return
        }
        
    }
}
