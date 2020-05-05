//
//  Created by Valentin Hartig on 01.05.20.
//

import Foundation
import ShellOut

extension FileManagment {
    
    func openProject(projectName: String) -> Void {
        headerMessage(msg: "Opening directory of \(projectName)")
        guard let projects = rootConfig.projects  else {
            errorMessage(msg: "Can't fetch Bubo projects")
            return
        }
        guard let url = projects[projectName] else {
            errorMessage(msg: "Can't open \(projectName). It is nor registered in Bubo runtime configuration")
            return
        }
        
        let fileManager = FileManager.default
        if fileManager.changeCurrentDirectoryPath(url.path) {
            do {
                try shellOut(to: "open .")
                return
            } catch {
                errorMessage(msg: "Failed to open project \(projectName)")
                return
            }
        }
    }
}
