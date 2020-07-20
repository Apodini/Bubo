//
//  Created by Valentin Hartig on 01.05.20.
//

import Foundation
import ShellOut
import ResourceManagerModule


extension OperationsManager {
    
    /// Opens a project in Finder
    ///
    /// - parameter pName: The name of the project to open. If `pName` is nil, the program checks if the current directory name is a project and opens it.

    public func openProject(pName: String?) -> Void {
        
        guard let (projectHandle, projectURL) = self.resourceManager.getProjectURL(projectName: pName) else {
            abortMessage(msg: "Refresh services")
            return
        }
        
        headerMessage(msg: "Opening directory of \(projectHandle)")

        /// Change to project directory and open it via ShellOut 
        if fileManager.changeCurrentDirectoryPath(projectURL.path) {
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
