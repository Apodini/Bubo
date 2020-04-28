//
//  Created by Valentin Hartig on 28.04.20.
//

import Foundation

extension FileManagment {
    func removeProject(projectName: String) -> Void {
        headerMessage(msg: "Removing project \(projectName)")
        guard var projects = rootConfig.projects  else {
            errorMessage(msg: "Can't fetch Bubo projects.")
            return
        }
        guard let url = projects.removeValue(forKey: projectName) else {
            errorMessage(msg: "Can't remove \(projectName). It does not exists in Bubo runtime configuration")
            return
        }
        
        let fileManager = FileManager.default
        let fileURL = URL(fileURLWithPath: url.path)
        do {
            try fileManager.removeItem(at: fileURL)
            successMessage(msg: "Removed project \(projectName)")
            rootConfig.projects = projects
            let fileManagement = FileManagment()
            fileManagement.encodeRootConfig(configFile: rootConfig)
            return
        } catch {
            errorMessage(msg: "Failed to remove project \(projectName)")
            return
        }
    }
}
