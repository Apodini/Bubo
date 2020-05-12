//
//  Created by Valentin Hartig on 01.05.20.
//

import Foundation
import ShellOut

extension ResourceManager {
    
    func openProject(pName: String?) -> Void {
        
        guard let (projectHandle, projectURL) = self.getProjectURL(projectName: pName) else {
            abortMessage(msg: "Refresh services")
            return
        }
        
        headerMessage(msg: "Opening directory of \(projectHandle)")

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
