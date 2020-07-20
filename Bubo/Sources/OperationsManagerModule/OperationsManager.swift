//
//  Created by Valentin Hartig on 19.07.20.
//

import Foundation
import ResourceManagerModule

public class OperationsManager {
    public var resourceManager: ResourceManager
    var fileManager: FileManager
    
    public init() {
        resourceManager = ResourceManager()
        fileManager = FileManager.default
    }
}
