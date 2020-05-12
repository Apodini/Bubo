//
//  Created by Valentin Hartig on 06.05.20.
//

import Foundation

extension ResourceManager {
    // Checks if the root repository of the application has been initialised
    func checkInit() -> Bool {
        guard getRootConfigPath() != nil else {
            return false
        }
        return true // Initialised if root config file exists
    }
}
