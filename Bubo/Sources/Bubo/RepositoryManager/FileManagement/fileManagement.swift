//
//  Created by Valentin Hartig on 20.04.20.
//

import Foundation

class FileManagment {
    // ----------------------- Declarations
    public var fileManager: FileManager
    
    // ----------------------- Initialisation
    
    init() {
        self.fileManager = FileManager.default
    }
    
    
    // ----------------------- Root repository initialisation functions
    func getBuboRepoDir() -> URL? {
        guard let filePath = rootConfig.rootRepoUrl else {
            NSLog("ERROR: Can't get root repo url path in getBuboRepoDir()")
            return nil
        }
        return filePath
    }
    
    
    func updateBuborc(config: Buborc, path: URL) {
        // Compare existing config file with new one and update existing
        NSLog("buborc at path \(path) updated")
    }
}
