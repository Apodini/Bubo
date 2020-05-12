//
//  Created by Valentin Hartig on 28.04.20.
//

import Foundation

extension ResourceManager {
    func removeService(projectName: String?, serviceName: String) -> Void {
        guard var (projectHandle, projectConfig) = self.decodeProjectConfig(pName: projectName) else {
            abortMessage(msg: "Removing service \(serviceName)")
            return
        }
        
        headerMessage(msg: "Removing service \(serviceName) from \(projectHandle)")
        
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
            self.encodeProjectConfig(pName: projectHandle, configData: projectConfig)
            return
        } catch {
            errorMessage(msg: "Failed to remove service \(serviceName) from project \(projectHandle)")
            return
        }
        
    }
}
