//
//  Created by Valentin Hartig on 12.05.20.
//

import Foundation

class ServiceManager {
    public let resourceManager: ResourceManager;
    public let fileManager: FileManager;
    public let parser: Parser

    init() {
        self.resourceManager = ResourceManager()
        self.fileManager = FileManager.default
        self.parser = Parser()
    }
}