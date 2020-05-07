//
//  Created by Valentin Hartig on 01.05.20.
//

import Foundation
import ShellOut

extension FileManagement {
    
    func openProject(projectName: String?) -> Void {
        
        guard let (projectHandle, projects) = self.fetchProjects(projectName: projectName) else {
            abortMessage(msg: "Deregistering project")
            return
        }
        
        headerMessage(msg: "Opening directory of \(projectHandle)")

        guard let url = projects[projectHandle] else {
            errorMessage(msg: "Can't open \(projectHandle). It is nor registered in Bubo runtime configuration")
            return
        }
        
        let fileManager = FileManager.default
        if fileManager.changeCurrentDirectoryPath(url.path) {
            do {
                try shellOut(to: "open .")
                return
            } catch {
                errorMessage(msg: "Failed to open project \(projectHandle)")
                return
            }
        }
    }
}
